package main

import (
	"flag"
	"fmt"
	"os"
	"path/filepath"

	"github.com/robfig/cron"
	"github.com/sanda0/linodsync/service"
)

func main() {

	exePath, err := os.Executable()
	if err != nil {
		fmt.Println("get exe path error: ", err)
	}
	exedir := filepath.Dir(exePath)

	configPath := flag.Bool("cc", false, "create linodsync.config.json")
	servicePath := flag.Bool("cs", false, "create service file")
	addTobackup := flag.Bool("add", false, "add to backup")
	runBackup := flag.Bool("run", false, "run backup")

	flag.Parse()

	if *configPath {
		service.CreateConfigJson(filepath.Join(exedir, "linodsync.config.json"))
	}

	if *servicePath {
		fmt.Println("create service file", *servicePath)
		service.CreateSystemdFile("linodsync", exedir+"/linodsync -run", "root")
	}

	if *addTobackup {
		service.AddToBackup(filepath.Join(exedir, "backup_config.json"))
	}

	if *runBackup {
		c := cron.New()
		c.AddFunc("@daily", func() {
			service.RunBackup(filepath.Join(exedir, "linodsync.config.json"), filepath.Join(exedir, "backup_config.json"), filepath.Join(exedir, "tmp"))
		})
		c.Start()

		select {}
	}
}
