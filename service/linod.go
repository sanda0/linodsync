package service

import (
	"bytes"
	"fmt"
	"io"
	"os"
	"strings"
	"time"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/credentials"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/s3"
	"github.com/sanda0/linodsync/appconfig"
)

func UploadFileToLinode(appconfig *appconfig.Config, objectKey, filePath string) error {

	sess, err := session.NewSession(&aws.Config{
		Region:   aws.String(appconfig.Region),
		Endpoint: aws.String(appconfig.Endpoint),
		Credentials: credentials.NewStaticCredentials(
			appconfig.AccessKey,
			appconfig.SecretKey,
			"", // Leave the token empty for Linode

		),
	})
	if err != nil {
		return err
	}

	svc := s3.New(sess)

	bucket := appconfig.Bucket

	file, err := os.Open(filePath)
	if err != nil {
		fmt.Fprintln(os.Stderr, "Error opening file:", err)
		return err
	}
	defer file.Close()

	key := objectKey

	// Read the contents of the file into a buffer
	var buf bytes.Buffer
	if _, err := io.Copy(&buf, file); err != nil {
		fmt.Fprintln(os.Stderr, "Error reading file:", err)
		return err
	}

	// This uploads the contents of the buffer to S3
	_, err = svc.PutObject(&s3.PutObjectInput{
		Bucket: aws.String(bucket),
		Key:    aws.String(key),
		Body:   bytes.NewReader(buf.Bytes()),
	})
	if err != nil {
		fmt.Println("Error uploading file:", err)
		return err
	}

	fmt.Println("File uploaded successfully!!!")

	return nil
}

func CreateFolderInBucket(appconfig *appconfig.Config, folderName string) error {
	// Initialize AWS session with Linode endpoint
	sess, err := session.NewSession(&aws.Config{
		Region:   aws.String(appconfig.Region),
		Endpoint: aws.String(appconfig.Endpoint),
		Credentials: credentials.NewStaticCredentials(
			appconfig.AccessKey,
			appconfig.SecretKey,
			"", // Leave the token empty for Linode
		),
	})
	if err != nil {
		return err
	}

	// Initialize S3 service client
	svc := s3.New(sess)

	// Append a trailing slash to simulate a folder
	if !bytes.HasSuffix([]byte(folderName), []byte("/")) {
		folderName += "/"
	}

	// Upload a zero-byte object with the folder name
	_, err = svc.PutObject(&s3.PutObjectInput{
		Bucket: aws.String(appconfig.Bucket),
		Key:    aws.String(folderName),
		Body:   bytes.NewReader(nil), // Zero-byte object
	})
	if err != nil {
		fmt.Println("Error creating folder:", err)
		return err
	}

	fmt.Println("Folder created successfully!!!")

	return nil
}

func DeleteOldZipFiles(appconfig *appconfig.Config, folderName string, days int) error {
	// Initialize AWS session with Linode endpoint
	sess, err := session.NewSession(&aws.Config{
		Region:   aws.String(appconfig.Region),
		Endpoint: aws.String(appconfig.Endpoint),
		Credentials: credentials.NewStaticCredentials(
			appconfig.AccessKey,
			appconfig.SecretKey,
			"", // Leave the token empty for Linode
		),
	})
	if err != nil {
		return fmt.Errorf("failed to create AWS session: %w", err)
	}

	// Initialize S3 service client
	svc := s3.New(sess)

	// Calculate the cutoff date
	cutoffDate := time.Now().AddDate(0, 0, -days)

	// List objects in the bucket with the specified folder prefix
	input := &s3.ListObjectsV2Input{
		Bucket: aws.String(appconfig.Bucket),
		Prefix: aws.String(folderName), // Filter by folder
	}

	for {
		// Retrieve the objects
		output, err := svc.ListObjectsV2(input)
		if err != nil {
			return fmt.Errorf("failed to list objects: %w", err)
		}

		// Iterate through the objects
		for _, obj := range output.Contents {
			fmt.Println(*obj.Key, obj.LastModified)
			// Check if the object is a .zip file and older than the cutoff date
			if strings.HasSuffix(*obj.Key, ".zip") && obj.LastModified.Before(cutoffDate) {
				// Delete the object
				_, err := svc.DeleteObject(&s3.DeleteObjectInput{
					Bucket: aws.String(appconfig.Bucket),
					Key:    obj.Key,
				})
				if err != nil {
					fmt.Printf("Failed to delete object %s: %v\n", *obj.Key, err)
					continue
				}
				fmt.Printf("Deleted: %s\n", *obj.Key)
			}
		}

		// Check if there are more objects to retrieve
		if !aws.BoolValue(output.IsTruncated) {
			break
		}

		// Continue to the next page of results
		input.ContinuationToken = output.NextContinuationToken
	}

	fmt.Println("Old zip file deletion completed.")
	return nil
}
