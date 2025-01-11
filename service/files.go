package service

import (
	"encoding/json"
	"fmt"
	"html/template"
	"io/ioutil"
	"os"
	"path/filepath"

	"github.com/joho/godotenv"
	"github.com/sanda0/linodsync/appconfig"
)

const systemdTemplate = `[Unit]
Description={{.Description}}
After=network.target

[Service]
ExecStart={{.ExecStart}}
Restart=always
User={{.User}}

[Install]
WantedBy=multi-user.target
`

type SystemdConfig struct {
	Description string
	ExecStart   string
	User        string
}

func CreateSystemdFile(serviceName, execStart, user string) error {
	// Define the service file path
	filePath := fmt.Sprintf("/etc/systemd/system/%s.service", serviceName)

	// Create the service file
	file, err := os.Create(filePath)
	if err != nil {
		return fmt.Errorf("failed to create service file: %w", err)
	}
	defer file.Close()

	// Prepare data for the template
	config := SystemdConfig{
		Description: fmt.Sprintf("%s Service", serviceName),
		ExecStart:   execStart,
		User:        user,
	}

	// Parse and execute the template
	tmpl, err := template.New("systemd").Parse(systemdTemplate)
	if err != nil {
		return fmt.Errorf("failed to parse systemd template: %w", err)
	}

	if err := tmpl.Execute(file, config); err != nil {
		return fmt.Errorf("failed to execute systemd template: %w", err)
	}

	fmt.Printf("Systemd service file created at: %s\n", filePath)
	return nil
}

func CreateConfigJson(outputPath string) {

	config := appconfig.Config{}

	file, err := os.Create(outputPath)
	if err != nil {
		fmt.Printf("create file error: %v\n", err)
	}
	defer file.Close()

	encoder := json.NewEncoder(file)
	encoder.SetIndent("", "   ")
	err = encoder.Encode(config)
	if err != nil {
		fmt.Printf("encode error: %v\n", err)
	}

	fmt.Printf("create linodsync.config.json success\n")
}

func CreateServiceFile() {}

func AddToBackup(backupConfigFilename string) {
	currentDir, err := os.Getwd()
	if err != nil {
		fmt.Printf("get current directory error: %v\n", err)
	}

	filename := filepath.Join(currentDir, "linodsync.json")
	fmt.Println(filename)
	file, err := os.Open(filename)
	if err != nil {
		fmt.Printf("open file error: %v\n", err)
	}
	defer file.Close()

	fileBytes, err := ioutil.ReadAll(file)
	if err != nil {
		fmt.Printf("read file error: %v\n", err)
	}

	linodsyncConfig := appconfig.LinodSyncConfig{}
	err = json.Unmarshal(fileBytes, &linodsyncConfig)
	if err != nil {
		fmt.Printf("unmarshal error: %v\n", err)
	}

	backoupConfig := ReadBackupConfigJsonFile(backupConfigFilename)

	for _, v := range backoupConfig.LinodSyncConfigList {
		if v.ZipFileName == linodsyncConfig.ZipFileName {
			fmt.Printf("zip file name %s already exists\n", linodsyncConfig.ZipFileName)
			return
		}
	}
	linodsyncConfig.EnvFile = filepath.Join(currentDir, linodsyncConfig.EnvFile)
	linodsyncConfig.Path = filepath.Join(currentDir)
	preProcessData := PreProcessLinodSyncFile(&linodsyncConfig)
	backoupConfig.LinodSyncConfigList = append(backoupConfig.LinodSyncConfigList, *preProcessData)

	backupConfigFile, err := os.Create(backupConfigFilename)
	if err != nil {
		fmt.Printf("create file error: %v\n", err)
	}
	defer backupConfigFile.Close()

	encoder := json.NewEncoder(backupConfigFile)
	encoder.SetIndent("", "   ")
	err = encoder.Encode(backoupConfig)
	if err != nil {
		fmt.Printf("encode error: %v\n", err)
	}

	fmt.Printf("add to backup success\n")
}

func PreProcessLinodSyncFile(object *appconfig.LinodSyncConfig) *appconfig.LinodSyncConfig {

	err := godotenv.Load(object.EnvFile)
	if err != nil {
		fmt.Printf("load env file error: %v\n", err)
	}
	object.Database.Connection = os.Getenv(object.Database.Connection)
	object.Database.Host = os.Getenv(object.Database.Host)
	object.Database.Port = os.Getenv(object.Database.Port)
	object.Database.Username = os.Getenv(object.Database.Username)
	object.Database.Password = os.Getenv(object.Database.Password)
	object.Database.DatabaseName = os.Getenv(object.Database.DatabaseName)

	return object
}

func ReadBackupConfigJsonFile(backupConfigFilename string) *appconfig.BackupConfig {
	file, err := os.Open(backupConfigFilename)
	if err != nil {
		fmt.Printf("open file error: %v\n", err)
	}
	defer file.Close()

	fileBytes, err := ioutil.ReadAll(file)
	if err != nil {
		fmt.Printf("read file error: %v\n", err)
	}

	backupConfig := appconfig.BackupConfig{}
	err = json.Unmarshal(fileBytes, &backupConfig)
	if err != nil {
		fmt.Printf("unmarshal error: %v\n", err)
	}

	return &backupConfig
}

func ReadConfigJsonFile(configFilename string) *appconfig.Config {
	file, err := os.Open(configFilename)
	if err != nil {
		fmt.Printf("open file error: %v\n", err)
	}
	defer file.Close()

	fileBytes, err := ioutil.ReadAll(file)
	if err != nil {
		fmt.Printf("read file error: %v\n", err)
	}

	config := appconfig.Config{}
	err = json.Unmarshal(fileBytes, &config)
	if err != nil {
		fmt.Printf("11unmarshal error: %v\n", err)
	}

	return &config
}
