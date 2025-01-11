package service

import (
	"archive/zip"
	"fmt"
	"io/ioutil"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"time"

	"github.com/sanda0/linodsync/appconfig"
)

func RunBackup(configFileName string, backupConfigFilename string, tmpFolder string) {

	err := os.Mkdir(tmpFolder, os.ModePerm)
	if err != nil {
		fmt.Printf("Failed to create tmp folder: %v\n", err)
	}
	fmt.Println("run backup")

	backupConfig := ReadBackupConfigJsonFile(backupConfigFilename)
	config := ReadConfigJsonFile(configFileName)

	for _, backup := range backupConfig.LinodSyncConfigList {
		fmt.Println(backup.ZipFileName)
		ExportDB(&backup, tmpFolder)
		ExportDir(&backup, tmpFolder)
		UploadToLinod(config, &backup, tmpFolder)
	}

}

func ExportDB(linodSyncConfig *appconfig.LinodSyncConfig, tmpFolder string) {
	folderPath := tmpFolder + "/" + linodSyncConfig.ZipFileName
	os.Mkdir(folderPath, os.ModePerm)
	sqlFile := fmt.Sprintf("%s/%s.sql", folderPath, linodSyncConfig.Database.DatabaseName)
	cmdStr := fmt.Sprintf("mysqldump -u%s -p%s  %s > %s", linodSyncConfig.Database.Username, linodSyncConfig.Database.Password, linodSyncConfig.Database.DatabaseName, sqlFile)
	cmd := exec.Command("bash", "-c", cmdStr)
	err := cmd.Run()
	if err != nil {
		fmt.Printf("Failed to export db: %v\n", err)
	}
}

func ExportDir(linodSyncConfig *appconfig.LinodSyncConfig, tmpFolder string) {
	folderPath := tmpFolder + "/" + linodSyncConfig.ZipFileName + "/dirs"
	os.Mkdir(folderPath, os.ModePerm)
	for _, dir := range linodSyncConfig.Dir {
		subName := strings.ReplaceAll(dir, "/", "_")
		MakeZip(filepath.Join(linodSyncConfig.Path, dir)+"/", folderPath+"/"+subName+".zip")
	}
}

func UploadToLinod(config *appconfig.Config, linodSyncConfig *appconfig.LinodSyncConfig, tmpFolder string) {

	CreateFolderInBucket(config, linodSyncConfig.ZipFileName)

	currentTime := time.Now()
	timestamp := currentTime.Format("20060102_150405")

	zipFile := fmt.Sprintf("%s/%s_%s.zip", tmpFolder, linodSyncConfig.ZipFileName, timestamp)
	MakeZip(
		fmt.Sprintf("%s/%s/", tmpFolder, linodSyncConfig.ZipFileName),
		zipFile,
	)

	os.RemoveAll(tmpFolder + "/" + linodSyncConfig.ZipFileName + "/")

	fullKey := linodSyncConfig.ZipFileName + "/" + linodSyncConfig.ZipFileName + "_" + timestamp + ".zip"
	UploadFileToLinode(config, fullKey, zipFile)

	os.Remove(zipFile)

	fmt.Println("upload to linod")

	DeleteOldZipFiles(config, linodSyncConfig.ZipFileName, config.RetentionDays)
}

func MakeZip(dir string, fileNamae string) {

	outputFile, err := os.Create(fileNamae)
	if err != nil {
		fmt.Println(err)
	}
	defer outputFile.Close()

	w := zip.NewWriter(outputFile)

	addFiles(w, dir, "")

	err = w.Close()
	if err != nil {
		fmt.Println(err)
	}

}

func addFiles(w *zip.Writer, basePath, baseInZip string) {
	// Open the Directory
	files, err := ioutil.ReadDir(basePath)
	if err != nil {
		fmt.Println(err)
	}

	for _, file := range files {
		if !file.IsDir() {
			dat, err := ioutil.ReadFile(basePath + file.Name())
			if err != nil {
				fmt.Println(err)
			}

			// Add some files to the archive.
			f, err := w.Create(baseInZip + file.Name())
			if err != nil {
				fmt.Println(err)
			}
			_, err = f.Write(dat)
			if err != nil {
				fmt.Println(err)
			}
		} else if file.IsDir() {

			// Recurse
			newBase := basePath + file.Name() + "/"

			addFiles(w, newBase, baseInZip+file.Name()+"/")
		}
	}
}
