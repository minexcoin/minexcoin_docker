package main

import (
	"net/http"
	"os"

	"github.com/btcsuite/btcd/rpcclient"
	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promhttp"
	"github.com/prometheus/common/log"
	"gopkg.in/alecthomas/kingpin.v2"
)

const version = "1.0.1"

func getEnv(name string) string {
	var envValue = os.Getenv(name)
	if len(envValue) == 0 {
		log.Fatal("env=" + name + " no value")
	}
	return envValue
}

func main() {
	var listendAddr = kingpin.Flag(
		"web.listen-address",
		"Address on which to expose metrics and web interface.",
	).Default(":8101").String()

	var metricsPath = kingpin.Flag(
		"web.telemetry-path",
		"Path under which to expose metrics.",
	).Default("/metrics").String()

	kingpin.Version(version)
	kingpin.HelpFlag.Short('h')
	kingpin.Parse()

	log.Info("Starting bitcoin_exporter ", version)

	config := &rpcclient.ConnConfig{
		Host:         getEnv("MNX_HOST"),
		User:         getEnv("MNX_USER"),
		Pass:         getEnv("MNX_PASS"),
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

	http.Handle(*metricsPath, promhttp.Handler())
	log.Info("Listening on", *listendAddr)
	log.Fatal(http.ListenAndServe(*listendAddr, nil))
}
