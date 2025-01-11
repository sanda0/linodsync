package appconfig

type Config struct {
	AccessKey      string `json:"access_key"`
	SecretKey      string `json:"secret_key"`
	Bucket         string `json:"bucket"`
	Region         string `json:"region"`
	Endpoint       string `json:"endpoint"`
	RetentionDays  int    `json:"retention_days"`
	BackupTime     string `json:"backup_time"`
	DiscordWebhook string `json:"discord_webhook"`
}

type LinodSyncConfig struct {
	EnvFile     string `json:"env_file"`
	ZipFileName string `json:"zip_file_name"`
	Path        string `json:"path"`
	Database    struct {
		Connection   string `json:"connection"`
		Host         string `json:"host"`
		Port         string `json:"port"`
		Username     string `json:"username"`
		Password     string `json:"password"`
		DatabaseName string `json:"database_name"`
	} `json:"database"`
	Dir []string `json:"dir"`
}

type BackupConfig struct {
	LinodSyncConfigList []LinodSyncConfig `json:"linodsync"`
}
