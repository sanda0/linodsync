# Linodsync
Linodsync is a Go-based application designed to back up your project directories and databases on a server to Linode Object Storage. 

## Installation
1. Create a directory for linodsync and download the pre-compiled binary into the server:
```bash
   mkdir linodsync && cd linodsync
   wget https://github.com/sanda0/linodsync/raw/refs/heads/main/linodsync
```
2. Make the binary executable by setting the executable permissions:
```bash
  chmod +x linodsync
```

## Project Configuration

1. Create `linodsync.json`.

In the project folder you want to back up, create a file named `linodsync.json` with the following structure:
```json
{
    "env_file": ".env",
    "zip_file_name": "project_backup",
    "database": {
        "connection": "DB_CONNECTION",
        "host": "DB_HOST",
        "port": "DB_PORT",
        "username": "DB_USERNAME",
        "password": "DB_PASSWORD",
        "database_name": "DB_DATABASE"
    },
    "dir": [
        "storage/app",
        "database/companies"
    ]
}
```
- `env_file`: Name of the .env file containing database credentials.
- `zip_file_name`: Name of the backup zip file.
- `database`: Database connection details, which will be extracted from the .env file.
- `dir`: List of directories to include in the backup.

2. Push the `linodsync.json` file to the server.

If you created the `linodsync.json` file on your local machine, push it to the project folder on the server.
```bash
git add linodsync.json
git commit -m "Add linodsync configuration"
git push
```
## Server Configuration
1. Generate `linodsync.config.json`

Run the following command to create the server configuration:
```bash
./linodsync -cc
```
This will generate a `linodsync.config.json` file with the following fields:
```json
{
    "access_key": "",
    "secret_key": "",
    "bucket": "",
    "region": "",
    "endpoint": "",
    "retention_days": 30
}
```
- `access_key`: Your Linode Object Storage access key.
- `secret_key`: Your Linode Object Storage secret key.
- `bucket`: Name of the bucket where backups will be stored.
- `region`: Region of the Linode bucket.
- `endpoint`: Linode Object Storage endpoint.
- `retention_days`: Number of days to retain backups.

2. Add Project to Backup

Navigate to the project folder on the server and run:

```bash
./linodsync --add
```
A success message will confirm the addition, and a `backup_config.json` file will be generated, listing all projects added for backup.

## Running as a Service
1. Generate Service File

Run the following command to create the `linodsync.service` file:
```bash
./linodsync -cs
```
The file will be saved at `/etc/systemd/system/linodsync.service`

2. Enable and Start the Service

Reload the systemd daemon and start the service:
```bash
systemctl daemon-reload
systemctl start linodsync.service
systemctl enable linodsync.service
```

3. Verify Service Status

Check the status of the service:
```bash
systemctl status linodsync.service
```

## Usage

To view help:

```bash
./linodsync -h
```
