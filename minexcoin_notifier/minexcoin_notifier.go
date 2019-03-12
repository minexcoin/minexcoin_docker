package main

import (
	"bytes"
	"encoding/base64"
	"encoding/binary"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"strconv"
	"strings"

	tgbotapi "github.com/go-telegram-bot-api/telegram-bot-api"
	"github.com/sirupsen/logrus"
	log "github.com/sirupsen/logrus"
	"github.com/syndtr/goleveldb/leveldb"
	"gopkg.in/alecthomas/kingpin.v2"
)

func rpcCall(jsonStr []byte) ([]byte, error) {
	auth := fmt.Sprintf("%s:%s", *appConfig.RPCUser, *appConfig.RPCPassword)

	base64Auth := base64.StdEncoding.EncodeToString([]byte(auth))

	req, err := http.NewRequest("POST", *appConfig.RPCHost, bytes.NewBuffer(jsonStr))
	req.Header.Add("Authorization", "Basic "+base64Auth)
	req.Header.Set("Content-Type", "application/json")

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		log.Error(err)
		return nil, err
	}
	defer resp.Body.Close()

	body, err := ioutil.ReadAll(resp.Body)
	return body, err
}

func validateAddress(address string) bool {
	type validateAddressTypeResult struct {
		Isvalid bool `json:"isvalid"`
	}

	type validateAddressType struct {
		Result validateAddressTypeResult `json:"result"`
	}

	var jsonStr = []byte(fmt.Sprintf(`{"jsonrpc":"1.0","id":"curltext","method":"validateaddress","params":["%s"]}`, address))
	body, err := rpcCall(jsonStr)

	if err != nil {
		log.Error(err)
		return false
	}
	log.Debug(string(body))

	var jsonResult validateAddressType
	json.Unmarshal(body, &jsonResult)

	log.Debug(jsonResult)

	return jsonResult.Result.Isvalid
}

func getBlockInfo(block string) blockInfoResult {
	var jsonStr = []byte(fmt.Sprintf(`{"jsonrpc":"1.0","id":"curltext","method":"getblock","params":["%s",2]}`, block))
	body, _ := rpcCall(jsonStr)

	var jsonResult blockInfoResult
	json.Unmarshal(body, &jsonResult)

	return jsonResult
}

type getAddressBalanceType struct {
	Address       string `json:"address"`
	Balance       string `json:"balance"`
	TotalReceived string `json:"totalReceived"`
}

func getAddressBalance(address string) getAddressBalanceType {
	url := fmt.Sprintf("https://minexexplorer.com/api/address/%s/get-balance", address)
	req, err := http.NewRequest("GET", url, nil)
	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		log.Panic(err)
	}
	defer resp.Body.Close()

	body, _ := ioutil.ReadAll(resp.Body)

	var jsonResult getAddressBalanceType
	json.Unmarshal(body, &jsonResult)

	return jsonResult
}

func blocknotify(w http.ResponseWriter, r *http.Request) {
	log.Info(r.URL.Path, " ", r.URL.Query())

	hash := r.URL.Query().Get("hash")
	if len(hash) == 0 {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("hash not found"))
		return
	}
	block := getBlockInfo(hash)

	if block.Result.Hash != hash {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("block not found"))
		return
	}

	for _, Tx := range block.Result.Tx {
		for _, Vout := range Tx.Vout {
			for _, Addresses := range Vout.ScriptPubKey.Addresses {

				i, err := db.Get([]byte(Addresses), nil)
				if err == nil {
					chatID := int64(binary.LittleEndian.Uint64(i))
					balance := getAddressBalance(Addresses)

					msg := tgbotapi.NewMessage(chatID, fmt.Sprintf("value=%f MNX id=%s balance=%s", Vout.Value, Tx.Txid, balance.Balance))
					_, err := bot.Send(msg)
					if err != nil {
						log.Error(err)
					}
				}
			}
		}
	}

	w.Write([]byte("ok"))
}

type blockInfoTxVoutScriptPubKey struct {
	Addresses []string `json:"addresses"`
}

type blockInfoTxVout struct {
	Value        float64                     `json:"value"`
	ScriptPubKey blockInfoTxVoutScriptPubKey `json:"scriptPubKey"`
}

type blockInfoTx struct {
	Txid string            `json:"txid"`
	Size int64             `json:"size"`
	Vout []blockInfoTxVout `json:"vout"`
}
type blockInfo struct {
	Hash string        `json:"hash"`
	Tx   []blockInfoTx `json:"tx"`
}
type blockInfoResult struct {
	Result blockInfo `json:"result"`
}

type appConfigType struct {
	Version            string
	Loglevel           *string
	RPCHost            *string
	RPCUser            *string
	RPCPassword        *string
	TelegramToken      *string
	LevelDBPath        *string
	BlocknotifyAddress *string
}

var appConfig = appConfigType{
	"1.0.0",
	kingpin.Flag(
		"log.level",
		"loging level",
	).Default("INFO").String(),
	kingpin.Flag(
		"rpc.host",
		"minexnode rpc address",
	).Default("http://127.0.0.1:17786").String(),
	kingpin.Flag(
		"rpc.user",
		"minexnode rpc user",
	).Default("user").String(),
	kingpin.Flag(
		"rpc.password",
		"minexnode rpc password",
	).Default("password").String(),
	kingpin.Flag(
		"telegram.token",
		"telegram token to process chat messages",
	).Required().String(),
	kingpin.Flag(
		"leveldb.path",
		"leveldb path",
	).Default("db").String(),
	kingpin.Flag(
		"blocknotify.address",
		"blocknotify tcp address",
	).Default("0.0.0.0:12808").String(),
}
var db = &leveldb.DB{}
var bot = &tgbotapi.BotAPI{}

func main() {
	var err error

	kingpin.Version(appConfig.Version)
	kingpin.HelpFlag.Short('h')
	kingpin.Parse()

	log.Info("Starting minexcoin_notifier ", appConfig.Version)

	level, err := logrus.ParseLevel(*appConfig.Loglevel)
	if err != nil {
		log.Error("wrong loglevel ", *appConfig.Loglevel)
	} else {
		log.SetLevel(level)
	}

	log.Info("Init database...")
	db, err = leveldb.OpenFile(*appConfig.LevelDBPath, nil)
	if err != nil {
		log.Panic(err)
	}
	defer db.Close()

	go func() {
		log.Info(fmt.Sprintf("Starting service blocknotify on %s", *appConfig.BlocknotifyAddress))
		http.HandleFunc("/block", blocknotify)
		log.Fatal(http.ListenAndServe(*appConfig.BlocknotifyAddress, nil))
	}()

	bot, err = tgbotapi.NewBotAPI(*appConfig.TelegramToken)
	if err != nil {
		log.Panic(err)
	}

	bot.Debug = false

	log.Printf("Authorized on account %s", bot.Self.UserName)

	u := tgbotapi.NewUpdate(0)
	u.Timeout = 60

	updates, err := bot.GetUpdatesChan(u)

	for update := range updates {
		if update.Message == nil { // ignore any non-Message Updates
			continue
		}
		log.Info(update.Message.Text)
		var message = "comand not found"

		args := strings.Split(update.Message.Text, " ")

		switch args[0] {
		case "/start":
			message = "welcome"
			break
		case "/dbStat":
			s := &leveldb.DBStats{}
			db.Stats(s)

			b, err := json.Marshal(s)
			if err != nil {
				log.Error(err)
				message = err.Error()
				break
			}
			message = string(b)
			break
		case "/dbAdd":
			if len(args) != 2 {
				message = "Usage /dbAdd {address}"
				break
			}

			if validateAddress(args[1]) != true {
				message = "address is not valid"
				break
			}
			_, err := db.Get([]byte(args[1]), nil)
			if err == nil {
				message = "address exists"
				break
			}

			b := make([]byte, 8)
			binary.LittleEndian.PutUint64(b, uint64(update.Message.Chat.ID))

			err = db.Put([]byte(args[1]), b, nil)
			if err != nil {
				log.Error(err)
				message = err.Error()
				break
			}

			message = fmt.Sprintf("address add %s", args[1])
			break
		case "/dbGet":
			if len(args) != 2 {
				message = "Usage /dbGet {address}"
				break
			}
			i, err := db.Get([]byte(args[1]), nil)
			if err != nil {
				message = err.Error()
				break
			}

			chatID := int64(binary.LittleEndian.Uint64(i))

			message = strconv.FormatInt(chatID, 10)
			break
		}

		msg := tgbotapi.NewMessage(update.Message.Chat.ID, message)
		_, err := bot.Send(msg)
		if err != nil {
			log.Error(err)
			msg := tgbotapi.NewMessage(update.Message.Chat.ID, err.Error())
			bot.Send(msg)
		}
	}
}
