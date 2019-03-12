package main

import (
	"net/http"

	"github.com/btcsuite/btcd/rpcclient"
	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promhttp"
	"github.com/prometheus/common/log"
	"gopkg.in/alecthomas/kingpin.v2"
)

type appConfigType struct {
	Version     string
	listendAddr *string
	metricsPath *string
	RPCHost     *string
	RPCUser     *string
	RPCPassword *string
}

var appConfig = appConfigType{
	"1.0.1",
	kingpin.Flag(
		"web.listen-address",
		"Address on which to expose metrics and web interface.",
	).Default(":8101").String(),
	kingpin.Flag(
		"web.telemetry-path",
		"Path under which to expose metrics.",
	).Default("/metrics").String(),
	kingpin.Flag(
		"rpc.host",
		"minexnode rpc address",
	).Default("127.0.0.1:17786").String(),
	kingpin.Flag(
		"rpc.user",
		"minexnode rpc user",
	).Default("user").String(),
	kingpin.Flag(
		"rpc.password",
		"minexnode rpc password",
	).Default("password").String(),
}

func main() {
	kingpin.Version(appConfig.Version)
	kingpin.HelpFlag.Short('h')
	kingpin.Parse()

	log.Info("Starting bitcoin_exporter ", appConfig.Version)

	config := &rpcclient.ConnConfig{
		Host:         *appConfig.RPCHost,
		User:         *appConfig.RPCUser,
		Pass:         *appConfig.RPCPassword,
		DisableTLS:   true,
		HTTPPostMode: true,
	}

	client, err := rpcclient.New(config, nil)
	if err != nil {
		log.Fatal(err)
	}

	defer client.Shutdown()

	prometheus.Register(prometheus.NewGaugeFunc(
		prometheus.GaugeOpts{
			Name: "bitcoin_block_count",
			Help: "Number of blocks",
		},
		func() float64 {
			blockCount, err := client.GetBlockCount()
			if err != nil {
				log.Fatal(err)
			}
			return float64(blockCount)
		},
	))

	prometheus.Register(prometheus.NewGaugeFunc(
		prometheus.GaugeOpts{
			Name: "bitcoin_raw_mempool_size",
			Help: "The number of transactions in rawmempool",
		},
		func() float64 {
			hashes, err := client.GetRawMempool()
			if err != nil {
				log.Fatal(err)
			}
			return float64(len(hashes))
		},
	))

	prometheus.Register(prometheus.NewGaugeFunc(
		prometheus.GaugeOpts{
			Name: "bitcoin_connected_peers",
			Help: "The number of connected peers",
		},
		func() float64 {
			peerInfo, err := client.GetPeerInfo()
			if err != nil {
				log.Fatal(err)
			}
			return float64(len(peerInfo))
		},
	))

	http.Handle(*appConfig.metricsPath, promhttp.Handler())
	log.Info("Listening on", *appConfig.listendAddr)
	log.Fatal(http.ListenAndServe(*appConfig.listendAddr, nil))
}
