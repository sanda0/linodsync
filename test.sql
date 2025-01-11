/*!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19  Distrib 10.11.8-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: pramix_pos_db
-- ------------------------------------------------------
-- Server version	10.11.8-MariaDB-0ubuntu0.24.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `accpkg_accounts`
--

DROP TABLE IF EXISTS `accpkg_accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `accpkg_accounts` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `type` varchar(255) NOT NULL,
  `parent_id` bigint(20) unsigned DEFAULT NULL,
  `ref_id` int(11) DEFAULT NULL,
  `ref_type` char(25) DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `accpkg_accounts_name_unique` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accpkg_accounts`
--

LOCK TABLES `accpkg_accounts` WRITE;
/*!40000 ALTER TABLE `accpkg_accounts` DISABLE KEYS */;
/*!40000 ALTER TABLE `accpkg_accounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `accpkg_entries`
--

DROP TABLE IF EXISTS `accpkg_entries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `accpkg_entries` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `from_account` bigint(20) unsigned NOT NULL,
  `to_account` bigint(20) unsigned NOT NULL,
  `debit` double NOT NULL DEFAULT 0,
  `credit` double NOT NULL DEFAULT 0,
  `balance` double NOT NULL DEFAULT 0,
  `ref_id` int(11) DEFAULT NULL,
  `ref_type` char(25) DEFAULT NULL,
  `description` varchar(60) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `accpkg_entries_from_account_foreign` (`from_account`),
  KEY `accpkg_entries_to_account_foreign` (`to_account`),
  CONSTRAINT `accpkg_entries_from_account_foreign` FOREIGN KEY (`from_account`) REFERENCES `accpkg_accounts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `accpkg_entries_to_account_foreign` FOREIGN KEY (`to_account`) REFERENCES `accpkg_accounts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accpkg_entries`
--

LOCK TABLES `accpkg_entries` WRITE;
/*!40000 ALTER TABLE `accpkg_entries` DISABLE KEYS */;
/*!40000 ALTER TABLE `accpkg_entries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `banks`
--

DROP TABLE IF EXISTS `banks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `banks` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `account_number` varchar(255) NOT NULL,
  `branch` varchar(255) NOT NULL,
  `bank_name` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `banks_account_number_unique` (`account_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `banks`
--

LOCK TABLES `banks` WRITE;
/*!40000 ALTER TABLE `banks` DISABLE KEYS */;
/*!40000 ALTER TABLE `banks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `booking_invoice`
--

DROP TABLE IF EXISTS `booking_invoice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `booking_invoice` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `booking_id` bigint(20) unsigned NOT NULL,
  `invoice_id` bigint(20) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `booking_invoice_booking_id_foreign` (`booking_id`),
  KEY `booking_invoice_invoice_id_foreign` (`invoice_id`),
  CONSTRAINT `booking_invoice_booking_id_foreign` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`) ON DELETE CASCADE,
  CONSTRAINT `booking_invoice_invoice_id_foreign` FOREIGN KEY (`invoice_id`) REFERENCES `invoices` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `booking_invoice`
--

LOCK TABLES `booking_invoice` WRITE;
/*!40000 ALTER TABLE `booking_invoice` DISABLE KEYS */;
/*!40000 ALTER TABLE `booking_invoice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bookings`
--

DROP TABLE IF EXISTS `bookings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bookings` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `customer_id` bigint(20) unsigned NOT NULL,
  `check_in` timestamp NULL DEFAULT NULL,
  `check_out` timestamp NULL DEFAULT NULL,
  `discount` double(8,2) NOT NULL DEFAULT 0.00,
  `total_price` double(8,2) NOT NULL DEFAULT 0.00,
  `discount_type` varchar(255) NOT NULL DEFAULT 'percentage',
  `payment_status` varchar(255) NOT NULL DEFAULT 'unpaid',
  `booking_status` varchar(255) NOT NULL DEFAULT 'booked',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `payment` double NOT NULL DEFAULT 0,
  `code` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `bookings_code_unique` (`code`),
  KEY `bookings_customer_id_foreign` (`customer_id`),
  CONSTRAINT `bookings_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bookings`
--

LOCK TABLES `bookings` WRITE;
/*!40000 ALTER TABLE `bookings` DISABLE KEYS */;
/*!40000 ALTER TABLE `bookings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cheque_grn_payments`
--

DROP TABLE IF EXISTS `cheque_grn_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cheque_grn_payments` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `cheque_id` bigint(20) unsigned NOT NULL,
  `grn_id` bigint(20) unsigned NOT NULL,
  `amount` decimal(15,2) NOT NULL,
  `date` date NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cheque_grn_payments`
--

LOCK TABLES `cheque_grn_payments` WRITE;
/*!40000 ALTER TABLE `cheque_grn_payments` DISABLE KEYS */;
/*!40000 ALTER TABLE `cheque_grn_payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cheque_invoice_payments`
--

DROP TABLE IF EXISTS `cheque_invoice_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cheque_invoice_payments` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `cheque_id` bigint(20) unsigned NOT NULL,
  `invoice_id` bigint(20) unsigned NOT NULL,
  `amount` decimal(15,2) NOT NULL,
  `date` date NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cheque_invoice_payments`
--

LOCK TABLES `cheque_invoice_payments` WRITE;
/*!40000 ALTER TABLE `cheque_invoice_payments` DISABLE KEYS */;
/*!40000 ALTER TABLE `cheque_invoice_payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cheques`
--

DROP TABLE IF EXISTS `cheques`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cheques` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `cheque_number` varchar(255) DEFAULT NULL,
  `cheque_date` date DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `payee_name` varchar(255) DEFAULT NULL,
  `payee_id` bigint(20) unsigned DEFAULT NULL,
  `payee_account_id` bigint(20) unsigned DEFAULT NULL,
  `payer_name` varchar(255) DEFAULT NULL,
  `payer_id` bigint(20) unsigned DEFAULT NULL,
  `payer_account_id` bigint(20) unsigned DEFAULT NULL,
  `bank_id` bigint(20) unsigned DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `ref_type` varchar(25) DEFAULT NULL,
  `ref_id` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cheques`
--

LOCK TABLES `cheques` WRITE;
/*!40000 ALTER TABLE `cheques` DISABLE KEYS */;
/*!40000 ALTER TABLE `cheques` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `companies`
--

DROP TABLE IF EXISTS `companies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `companies` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `country` varchar(255) DEFAULT NULL,
  `zip` varchar(255) DEFAULT NULL,
  `logo` varchar(255) DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  `status` varchar(255) NOT NULL DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `companies_email_unique` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `companies`
--

LOCK TABLES `companies` WRITE;
/*!40000 ALTER TABLE `companies` DISABLE KEYS */;
INSERT INTO `companies` VALUES
(1,'Pramix','test@pramix.com','1234567890','123, Test Address','Test City','Test State','Test Country','123456','logo.png','https://pramix.com','active','2024-11-25 11:18:10','2024-11-25 11:18:10'),
(2,'pramix','info@pramix.com','0769852321','ragam','ragama','sdsad','dsadsa','232',NULL,'dsdasd','active','2024-11-27 23:29:13','2024-11-27 23:29:13'),
(3,'fghdfg','sdsad@dsfdsfsd','345345','534','543543','5435','435345','5345',NULL,'dsfsdfdsfsd','active','2024-12-03 02:57:19','2024-12-03 02:57:19'),
(4,'dsfdsfsdf','fdsfsd@sdsadas','dasdsad','dsadsad','sdsad','dsadsa','dsadasd','dasdas',NULL,'sdsadas','active','2024-12-03 03:04:27','2024-12-03 03:04:27'),
(5,'sandakelum priyamantha','sandakelum.dev@gmail.com','+94769438974','169,ebbawala, mananwaththa','matale','centel','LK','2114',NULL,NULL,'active','2024-12-29 10:38:33','2024-12-29 10:38:33');
/*!40000 ALTER TABLE `companies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `company_payments`
--

DROP TABLE IF EXISTS `company_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `company_payments` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `company_id` bigint(20) unsigned NOT NULL,
  `payment_period` varchar(255) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `payment_slip` varchar(255) DEFAULT NULL,
  `payment_date` date NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `payment_status` enum('unpaid','paid') NOT NULL DEFAULT 'unpaid',
  `payment_method` enum('bank_transfer','card') NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `company_payments`
--

LOCK TABLES `company_payments` WRITE;
/*!40000 ALTER TABLE `company_payments` DISABLE KEYS */;
/*!40000 ALTER TABLE `company_payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `configuration_category`
--

DROP TABLE IF EXISTS `configuration_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `configuration_category` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `status` char(1) NOT NULL,
  `created_by` int(11) NOT NULL,
  `updated_by` int(11) NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `configuration_category`
--

LOCK TABLES `configuration_category` WRITE;
/*!40000 ALTER TABLE `configuration_category` DISABLE KEYS */;
/*!40000 ALTER TABLE `configuration_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `configurations`
--

DROP TABLE IF EXISTS `configurations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `configurations` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `display_name` varchar(255) NOT NULL,
  `config_type` char(2) NOT NULL,
  `options` text DEFAULT NULL,
  `default_value` varchar(255) DEFAULT NULL,
  `value` varchar(255) DEFAULT NULL,
  `options_array` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`options_array`)),
  `category_id` int(11) NOT NULL,
  `status` char(1) NOT NULL,
  `created_by` int(11) NOT NULL,
  `updated_by` int(11) NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `configurations`
--

LOCK TABLES `configurations` WRITE;
/*!40000 ALTER TABLE `configurations` DISABLE KEYS */;
/*!40000 ALTER TABLE `configurations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer_payments`
--

DROP TABLE IF EXISTS `customer_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customer_payments` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `date` date NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `customer_id` bigint(20) unsigned NOT NULL,
  `payment_method` varchar(255) DEFAULT NULL,
  `code` varchar(255) DEFAULT NULL,
  `note` varchar(60) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `customer_payments_code_unique` (`code`),
  KEY `customer_payments_customer_id_foreign` (`customer_id`),
  CONSTRAINT `customer_payments_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_payments`
--

LOCK TABLES `customer_payments` WRITE;
/*!40000 ALTER TABLE `customer_payments` DISABLE KEYS */;
/*!40000 ALTER TABLE `customer_payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customers` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `code` varchar(255) NOT NULL,
  `created_by` int(10) unsigned DEFAULT NULL,
  `updated_by` int(10) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `customers_code_unique` (`code`),
  UNIQUE KEY `customers_email_unique` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customers`
--

LOCK TABLES `customers` WRITE;
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
/*!40000 ALTER TABLE `customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employees`
--

DROP TABLE IF EXISTS `employees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `employees` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `phone` varchar(255) NOT NULL,
  `address` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `code` varchar(255) NOT NULL,
  `created_by` int(10) unsigned DEFAULT NULL,
  `updated_by` int(10) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `employees_code_unique` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employees`
--

LOCK TABLES `employees` WRITE;
/*!40000 ALTER TABLE `employees` DISABLE KEYS */;
/*!40000 ALTER TABLE `employees` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `failed_jobs`
--

DROP TABLE IF EXISTS `failed_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `failed_jobs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `failed_jobs`
--

LOCK TABLES `failed_jobs` WRITE;
/*!40000 ALTER TABLE `failed_jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `failed_jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `grn`
--

DROP TABLE IF EXISTS `grn`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `grn` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `supplier_id` bigint(20) unsigned DEFAULT NULL,
  `date` date DEFAULT NULL,
  `code` varchar(255) DEFAULT NULL,
  `discount` decimal(8,2) DEFAULT NULL,
  `sub_total` decimal(15,2) DEFAULT NULL,
  `payment` varchar(255) DEFAULT NULL,
  `status` varchar(255) NOT NULL DEFAULT 'D',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `discount_type` varchar(255) DEFAULT NULL,
  `payment_status` varchar(255) NOT NULL DEFAULT 'unpaid',
  `notes` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `grn`
--

LOCK TABLES `grn` WRITE;
/*!40000 ALTER TABLE `grn` DISABLE KEYS */;
/*!40000 ALTER TABLE `grn` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `grn_products`
--

DROP TABLE IF EXISTS `grn_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `grn_products` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `grn_id` bigint(20) unsigned NOT NULL,
  `product_id` bigint(20) unsigned NOT NULL,
  `qty` double NOT NULL,
  `available_qty` double NOT NULL,
  `grn_return_qty` double DEFAULT 0,
  `invoice_return_qty` double DEFAULT 0,
  `discarded_qty` double DEFAULT 0,
  `cost` double NOT NULL,
  `sale_price` double NOT NULL,
  `status` varchar(255) NOT NULL DEFAULT 'draft',
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `expire_date` date DEFAULT NULL,
  `purchase_avg_discount` double NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `grn_products_grn_id_foreign` (`grn_id`),
  KEY `grn_products_product_id_foreign` (`product_id`),
  CONSTRAINT `grn_products_grn_id_foreign` FOREIGN KEY (`grn_id`) REFERENCES `grn` (`id`) ON DELETE CASCADE,
  CONSTRAINT `grn_products_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `grn_products`
--

LOCK TABLES `grn_products` WRITE;
/*!40000 ALTER TABLE `grn_products` DISABLE KEYS */;
/*!40000 ALTER TABLE `grn_products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `grn_return`
--

DROP TABLE IF EXISTS `grn_return`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `grn_return` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `grn_id` bigint(20) unsigned DEFAULT NULL,
  `supplier_id` bigint(20) unsigned DEFAULT NULL,
  `date` date DEFAULT NULL,
  `code` varchar(255) DEFAULT NULL,
  `discount` decimal(8,2) DEFAULT NULL,
  `sub_total` decimal(15,2) DEFAULT NULL,
  `payment` varchar(255) DEFAULT NULL,
  `status` varchar(255) NOT NULL DEFAULT 'D',
  `discount_type` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `grn_return`
--

LOCK TABLES `grn_return` WRITE;
/*!40000 ALTER TABLE `grn_return` DISABLE KEYS */;
/*!40000 ALTER TABLE `grn_return` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `grn_return_products`
--

DROP TABLE IF EXISTS `grn_return_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `grn_return_products` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `grn_return_id` bigint(20) unsigned NOT NULL,
  `product_id` bigint(20) unsigned NOT NULL,
  `qty` int(11) NOT NULL,
  `sale_price` decimal(8,2) NOT NULL,
  `cost` decimal(8,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `grn_return_products`
--

LOCK TABLES `grn_return_products` WRITE;
/*!40000 ALTER TABLE `grn_return_products` DISABLE KEYS */;
/*!40000 ALTER TABLE `grn_return_products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invoice_products`
--

DROP TABLE IF EXISTS `invoice_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `invoice_products` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `invoice_id` bigint(20) unsigned NOT NULL,
  `product_id` bigint(20) unsigned NOT NULL,
  `qty` double NOT NULL,
  `return_qty` double DEFAULT 0,
  `sale_price` double NOT NULL,
  `cost` double NOT NULL,
  `status` varchar(255) NOT NULL DEFAULT 'draft',
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `grn_product_id` bigint(20) unsigned DEFAULT NULL,
  `discount` decimal(10,2) DEFAULT NULL,
  `discount_type` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `invoice_products_invoice_id_foreign` (`invoice_id`),
  KEY `invoice_products_grn_product_id_foreign` (`grn_product_id`),
  CONSTRAINT `invoice_products_invoice_id_foreign` FOREIGN KEY (`invoice_id`) REFERENCES `invoices` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invoice_products`
--

LOCK TABLES `invoice_products` WRITE;
/*!40000 ALTER TABLE `invoice_products` DISABLE KEYS */;
/*!40000 ALTER TABLE `invoice_products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invoice_return_products`
--

DROP TABLE IF EXISTS `invoice_return_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `invoice_return_products` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `invoice_return_id` bigint(20) unsigned NOT NULL,
  `product_id` bigint(20) unsigned NOT NULL,
  `qty` double NOT NULL,
  `discarded` tinyint(1) NOT NULL,
  `avg_sale_price` double NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `invoice_product_id` bigint(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invoice_return_products`
--

LOCK TABLES `invoice_return_products` WRITE;
/*!40000 ALTER TABLE `invoice_return_products` DISABLE KEYS */;
/*!40000 ALTER TABLE `invoice_return_products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invoice_returns`
--

DROP TABLE IF EXISTS `invoice_returns`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `invoice_returns` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `invoice_id` bigint(20) unsigned NOT NULL,
  `customer_id` bigint(20) unsigned NOT NULL,
  `date` date NOT NULL,
  `code` varchar(255) DEFAULT NULL,
  `discount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `sub_total` decimal(10,2) NOT NULL DEFAULT 0.00,
  `status` varchar(255) NOT NULL DEFAULT 'draft',
  `discount_type` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `invoice_returns_invoice_id_foreign` (`invoice_id`),
  KEY `invoice_returns_customer_id_foreign` (`customer_id`),
  CONSTRAINT `invoice_returns_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE,
  CONSTRAINT `invoice_returns_invoice_id_foreign` FOREIGN KEY (`invoice_id`) REFERENCES `invoices` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invoice_returns`
--

LOCK TABLES `invoice_returns` WRITE;
/*!40000 ALTER TABLE `invoice_returns` DISABLE KEYS */;
/*!40000 ALTER TABLE `invoice_returns` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invoices`
--

DROP TABLE IF EXISTS `invoices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `invoices` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `customer_id` bigint(20) unsigned NOT NULL,
  `date` date DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `code` varchar(255) DEFAULT NULL,
  `discount` decimal(10,2) DEFAULT NULL,
  `sub_total` decimal(10,2) DEFAULT NULL,
  `payment` decimal(10,2) DEFAULT NULL,
  `service_fee` decimal(10,2) DEFAULT NULL,
  `service_fee_type` varchar(255) DEFAULT NULL,
  `payment_status` varchar(255) NOT NULL DEFAULT 'unpaid',
  `status` varchar(255) NOT NULL DEFAULT 'draft',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `discount_type` varchar(255) DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `notes` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invoices`
--

LOCK TABLES `invoices` WRITE;
/*!40000 ALTER TABLE `invoices` DISABLE KEYS */;
/*!40000 ALTER TABLE `invoices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `media`
--

DROP TABLE IF EXISTS `media`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `media` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `model_type` varchar(255) NOT NULL,
  `model_id` bigint(20) unsigned NOT NULL,
  `uuid` char(36) DEFAULT NULL,
  `collection_name` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `file_name` varchar(255) NOT NULL,
  `mime_type` varchar(255) DEFAULT NULL,
  `disk` varchar(255) NOT NULL,
  `conversions_disk` varchar(255) DEFAULT NULL,
  `size` bigint(20) unsigned NOT NULL,
  `manipulations` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`manipulations`)),
  `custom_properties` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`custom_properties`)),
  `generated_conversions` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`generated_conversions`)),
  `responsive_images` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`responsive_images`)),
  `order_column` int(10) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `media_uuid_unique` (`uuid`),
  KEY `media_model_type_model_id_index` (`model_type`,`model_id`),
  KEY `media_order_column_index` (`order_column`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `media`
--

LOCK TABLES `media` WRITE;
/*!40000 ALTER TABLE `media` DISABLE KEYS */;
INSERT INTO `media` VALUES
(1,'Pramix\\XCompany\\Models\\Company',2,'8372c131-89e8-497d-acd4-0df468e3107c','company_logo/2','Screenshot from 2024-10-11 19-45-18','Screenshot-from-2024-10-11-19-45-18.png','image/png','public','public',108121,'[]','[]','[]','[]',1,'2024-11-27 23:29:13','2024-11-27 23:29:13'),
(2,'Pramix\\XCompany\\Models\\Company',3,'93c6576d-c65d-4118-a385-7e9fa34b0445','company_logo/3','Screenshot from 2024-10-11 19-45-18','Screenshot-from-2024-10-11-19-45-18.png','image/png','public','public',108121,'[]','[]','[]','[]',1,'2024-12-03 02:57:19','2024-12-03 02:57:19'),
(3,'Pramix\\XCompany\\Models\\Company',5,'ce158768-0765-4227-b822-c48dc1326e4c','company_logo/5','2024-12-09_22-56','2024-12-09_22-56.png','image/png','public','public',151097,'[]','[]','[]','[]',1,'2024-12-29 10:38:33','2024-12-29 10:38:33');
/*!40000 ALTER TABLE `media` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `migrations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` VALUES
(1,'2014_10_12_000000_create_users_table',1),
(2,'2014_10_12_100000_create_password_resets_table',1),
(3,'2019_08_19_000000_create_failed_jobs_table',1),
(4,'2019_09_24_190917_create_configurations_table',1),
(5,'2019_09_25_035554_create_configurations_category_table',1),
(6,'2019_12_14_000001_create_personal_access_tokens_table',1),
(7,'2022_11_18_004739_create_permission_tables',1),
(8,'2024_03_04_070851_create_accounts_table',1),
(9,'2024_03_04_070913_create_records_table',1),
(10,'2024_08_28_101102_create_employees_table',1),
(11,'2024_08_28_121015_add_deleted_at_column_to_employees_table',1),
(12,'2024_08_28_135913_create_suppliers_table',1),
(13,'2024_08_28_153641_create_customers_table',1),
(14,'2024_08_28_165143_create_product_categories_table',1),
(15,'2024_08_28_182059_create_products_table',1),
(16,'2024_08_29_035300_create_inventory_logs_table',1),
(17,'2024_08_29_042151_create_invoices_table',1),
(18,'2024_08_29_042220_create_invoice_products_table',1),
(19,'2024_08_29_105559_create_grn_table',1),
(20,'2024_08_30_052810_add_nullable_date_to_invoices_table',1),
(21,'2024_08_30_053514_update_invoices_table_nullable_columns',1),
(22,'2024_08_30_113220_add_deleted_at_to_inventory_logs_table',1),
(23,'2024_09_02_040239_drop_inventory_log',1),
(24,'2024_09_02_040408_create_grn_products_table',1),
(25,'2024_09_02_041301_drop_invoice_produts',1),
(26,'2024_09_02_041348_create_invoice_product_table',1),
(27,'2024_09_02_050637_add_grn_product_id_to_invoice_product_table',1),
(28,'2024_09_03_172806_add_discount_type_to_invoices_table',1),
(29,'2024_09_12_175244_add_discount_type_to_grn_table',1),
(30,'2024_09_16_112823_create_invoice_returns_table',1),
(31,'2024_09_16_120228_create_invoice_return_products_table',1),
(32,'2024_09_16_162227_add_avg_sale_price_to_invoice_return_products_table',1),
(33,'2024_09_18_063613_add_return_qty_to_invoice_products_table',1),
(34,'2024_09_18_075843_add_invoice_product_id_to_invoice_return_products_table',1),
(35,'2024_09_18_114203_create_room_types_table',1),
(36,'2024_09_18_115420_create_rooms_table',1),
(37,'2024_09_18_115506_create_room_bookings_table',1),
(38,'2024_09_19_170001_add_reorder_col_products_table',1),
(39,'2024_09_22_122537_create_customer_payments_table',1),
(40,'2024_09_22_141928_update_code_nullable_in_customer_payments_table',1),
(41,'2024_09_23_101105_create_supplier_payments_table',1),
(42,'2024_09_23_102840_create_grn_return_table',1),
(43,'2024_09_25_003022_create_grn_return_products_table',1),
(44,'2024_09_27_150744_add_expire_date_to_products_table',1),
(45,'2024_10_16_113136_createnew_rooms_bookings_table_create',1),
(46,'2024_10_19_100846_create_media_table',1),
(47,'2024_10_20_054519_update_sku_and_unit_nullable_in_products_table',1),
(48,'2024_10_20_072007_add_expire_date_to_grn_products_table',1),
(49,'2024_10_21_081047_create_booking_invoice_table',1),
(50,'2024_10_22_065413_add_payment_and_code_for_bookings_table',1),
(51,'2024_10_26_135629_add_purchase_avg_discount_to_grn_products',1),
(52,'2024_10_28_175306_add_status_to_products_table',1),
(53,'2024_10_28_191517_add_payemnt_status_to_invoices',1),
(54,'2024_10_28_192044_add_payemnt_status_to_grn',1),
(55,'2024_10_29_100015_create_banks_table',1),
(56,'2024_10_30_040230_add_note_to_customer_payments_table',1),
(57,'2024_10_30_040830_add_note_to_supplier_payments_table',1),
(58,'2024_10_30_112309_change_payment_method_datatype',1),
(59,'2024_10_30_112325_change_payment_method_datatype',1),
(60,'2024_11_04_104536_add_type_column_to_products_table',1),
(61,'2024_11_05_180059_remove_grn_product_id_from_invoice_products_table',1),
(62,'2024_11_06_101604_add_service_fee_and_service_fee_type_to_invoices_table',1),
(63,'2024_11_11_053353_unique_room_no_in_rooms',1),
(64,'2024_11_13_161423_increase_ref_type_size',1),
(65,'2024_11_13_161443_increase_ref_type_size',1),
(66,'2024_11_22_105100_create_companies_table',1),
(67,'2024_11_22_105240_create_company_payments_table',1),
(68,'2024_11_22_110413_change_user_table_add_company_id',1),
(69,'2024_11_28_085847_add_deleted_at_to_invoices_table',2),
(70,'2024_11_30_091840_create_cheques_table',3),
(71,'2024_11_30_091940_create_cheques_table',3),
(72,'2024_12_19_053321_create_cheque_invoice_payments_table',3),
(73,'2024_12_19_102219_create_cheque_grn_payments_table',3),
(74,'2024_12_26_095143_create_quotations_table',4),
(75,'2024_12_26_141927_create_quotation_products_table',4),
(76,'2024_12_30_071207_add_due_date_to_invoices_table',5),
(77,'2024_12_30_073247_add_notes_to_invoices',5),
(78,'2024_12_30_132519_add_notes_to_quotations',6),
(79,'2024_12_31_173432_add_notes_to_grn',7),
(80,'2025_01_02_062945_add_discount_and_discount_type_fields_to_invoice_products_table',8);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `model_has_permissions`
--

DROP TABLE IF EXISTS `model_has_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `model_has_permissions` (
  `permission_id` bigint(20) unsigned NOT NULL,
  `model_type` varchar(255) NOT NULL,
  `model_id` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`permission_id`,`model_id`,`model_type`),
  KEY `model_has_permissions_model_id_model_type_index` (`model_id`,`model_type`),
  CONSTRAINT `model_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `model_has_permissions`
--

LOCK TABLES `model_has_permissions` WRITE;
/*!40000 ALTER TABLE `model_has_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `model_has_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `model_has_roles`
--

DROP TABLE IF EXISTS `model_has_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `model_has_roles` (
  `role_id` bigint(20) unsigned NOT NULL,
  `model_type` varchar(255) NOT NULL,
  `model_id` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`role_id`,`model_id`,`model_type`),
  KEY `model_has_roles_model_id_model_type_index` (`model_id`,`model_type`),
  CONSTRAINT `model_has_roles_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `model_has_roles`
--

LOCK TABLES `model_has_roles` WRITE;
/*!40000 ALTER TABLE `model_has_roles` DISABLE KEYS */;
INSERT INTO `model_has_roles` VALUES
(1,'Pramix\\XAuth\\Models\\User',3),
(1,'Pramix\\XAuth\\Models\\User',4),
(1,'Pramix\\XAuth\\Models\\User',5);
/*!40000 ALTER TABLE `model_has_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_resets`
--

DROP TABLE IF EXISTS `password_resets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `password_resets` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  KEY `password_resets_email_index` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_resets`
--

LOCK TABLES `password_resets` WRITE;
/*!40000 ALTER TABLE `password_resets` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_resets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permissions`
--

DROP TABLE IF EXISTS `permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `permissions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `display_name` varchar(255) DEFAULT NULL,
  `guard_name` varchar(255) NOT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `permissions_name_guard_name_unique` (`name`,`guard_name`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permissions`
--

LOCK TABLES `permissions` WRITE;
/*!40000 ALTER TABLE `permissions` DISABLE KEYS */;
INSERT INTO `permissions` VALUES
(1,'MANAGE_SETTING','Manage setting','web',NULL,'2024-11-25 11:18:09','2024-11-25 11:18:09'),
(2,'MANAGE_ROLES','Manage roles','web',NULL,'2024-11-25 11:18:09','2024-11-25 11:18:09'),
(3,'ADD_ROLES','Add roles','web',2,'2024-11-25 11:18:09','2024-11-25 11:18:09'),
(4,'EDIT_ROLES','Edit roles','web',2,'2024-11-25 11:18:09','2024-11-25 11:18:09'),
(5,'DELETE_ROLES','Delete roles','web',2,'2024-11-25 11:18:09','2024-11-25 11:18:09'),
(6,'MANAGE_PERMISSIONS','Manage permissions','web',NULL,'2024-11-25 11:18:09','2024-11-25 11:18:09'),
(7,'ADD_PERMISSIONS','Add permissions','web',6,'2024-11-25 11:18:09','2024-11-25 11:18:09'),
(8,'EDIT_PERMISSIONS','Edit permissions','web',6,'2024-11-25 11:18:09','2024-11-25 11:18:09'),
(9,'DELETE_PERMISSIONS','Delete permissions','web',6,'2024-11-25 11:18:09','2024-11-25 11:18:09'),
(10,'MANAGE_USERS','Manage users','web',NULL,'2024-11-25 11:18:09','2024-11-25 11:18:09'),
(11,'ADD_USERS','Add users','web',10,'2024-11-25 11:18:09','2024-11-25 11:18:09'),
(12,'EDIT_USERS','Edit users','web',10,'2024-11-25 11:18:09','2024-11-25 11:18:09'),
(13,'DELETE_USERS','Delete users','web',10,'2024-11-25 11:18:09','2024-11-25 11:18:09'),
(14,'MANAGE_CONFIGURATION','Manage configuration','web',NULL,'2024-11-25 11:18:09','2024-11-25 11:18:09'),
(15,'ADD_CONFIGURATIONS','Add configurations','web',14,'2024-11-25 11:18:09','2024-11-25 11:18:09'),
(16,'EDIT_CONFIGURATIONS','Edit configurations','web',14,'2024-11-25 11:18:09','2024-11-25 11:18:09'),
(17,'DELETE_CONFIGURATIONS','Delete configurations','web',14,'2024-11-25 11:18:09','2024-11-25 11:18:09'),
(18,'MANAGE_CONFIGURATION_CATEGORIES','Manage configuration categories','web',NULL,'2024-11-25 11:18:09','2024-11-25 11:18:09'),
(19,'ADD_CONFIGURATION_CATEGORIES','Add configuration categories','web',18,'2024-11-25 11:18:09','2024-11-25 11:18:09'),
(20,'EDIT_CONFIGURATION_CATEGORIES','Edit configuration categories','web',18,'2024-11-25 11:18:09','2024-11-25 11:18:09'),
(21,'DELETE_CONFIGURATION_CATEGORIES','Delete configuration categories','web',18,'2024-11-25 11:18:09','2024-11-25 11:18:09'),
(22,'MANAGE_PEOPLE','Manage People','web',NULL,'2024-11-25 11:18:09','2024-11-25 11:18:09'),
(23,'MANAGE_EMPLOYEE','Manage employee','web',NULL,'2024-11-25 11:18:09','2024-11-25 11:18:09'),
(24,'ADD_EMPLOYEE','Add employee','web',23,'2024-11-25 11:18:09','2024-11-25 11:18:09'),
(25,'EDIT_EMPLOYEE','Edit employee','web',23,'2024-11-25 11:18:09','2024-11-25 11:18:09'),
(26,'DELETE_EMPLOYEE','Delete employee','web',23,'2024-11-25 11:18:09','2024-11-25 11:18:09'),
(27,'MANAGE_SUPPLIER','Manage supplier','web',NULL,'2024-11-25 11:18:09','2024-11-25 11:18:09'),
(28,'ADD_SUPPLIER','Add supplier','web',27,'2024-11-25 11:18:09','2024-11-25 11:18:09'),
(29,'EDIT_SUPPLIER','Edit supplier','web',27,'2024-11-25 11:18:09','2024-11-25 11:18:09'),
(30,'DELETE_SUPPLIER','Delete supplier','web',27,'2024-11-25 11:18:09','2024-11-25 11:18:09'),
(31,'MANAGE_CUSTOMER','Manage customer','web',NULL,'2024-11-25 11:18:10','2024-11-25 11:18:10'),
(32,'ADD_CUSTOMER','Add customer','web',31,'2024-11-25 11:18:10','2024-11-25 11:18:10'),
(33,'EDIT_CUSTOMER','Edit customer','web',31,'2024-11-25 11:18:10','2024-11-25 11:18:10'),
(34,'DELETE_CUSTOMER','Delete customer','web',31,'2024-11-25 11:18:10','2024-11-25 11:18:10');
/*!40000 ALTER TABLE `permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `personal_access_tokens`
--

DROP TABLE IF EXISTS `personal_access_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `personal_access_tokens`
--

LOCK TABLES `personal_access_tokens` WRITE;
/*!40000 ALTER TABLE `personal_access_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `personal_access_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_categories`
--

DROP TABLE IF EXISTS `product_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_categories` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_categories`
--

LOCK TABLES `product_categories` WRITE;
/*!40000 ALTER TABLE `product_categories` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `products` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `category_id` bigint(20) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `SKU` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `unit` varchar(255) DEFAULT NULL,
  `cost` decimal(10,2) NOT NULL DEFAULT 0.00,
  `price` decimal(10,2) NOT NULL DEFAULT 0.00,
  `status` varchar(255) NOT NULL DEFAULT 'Active',
  `expire_date` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `reorder` double DEFAULT 0,
  `type` varchar(255) NOT NULL DEFAULT 'inventory',
  `barcode` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `products_barcode_unique` (`barcode`),
  UNIQUE KEY `products_sku_unique` (`SKU`),
  KEY `products_category_id_foreign` (`category_id`),
  CONSTRAINT `products_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `product_categories` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quotation_products`
--

DROP TABLE IF EXISTS `quotation_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `quotation_products` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `quotation_id` bigint(20) unsigned NOT NULL,
  `product_id` bigint(20) unsigned NOT NULL,
  `quantity` int(11) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quotation_products`
--

LOCK TABLES `quotation_products` WRITE;
/*!40000 ALTER TABLE `quotation_products` DISABLE KEYS */;
/*!40000 ALTER TABLE `quotation_products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quotations`
--

DROP TABLE IF EXISTS `quotations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `quotations` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `customer_id` bigint(20) unsigned NOT NULL,
  `date` date NOT NULL,
  `code` varchar(255) DEFAULT NULL,
  `discount` decimal(10,2) DEFAULT NULL,
  `discount_type` varchar(255) NOT NULL DEFAULT 'fixed',
  `sub_total` decimal(10,2) NOT NULL,
  `status` varchar(255) NOT NULL DEFAULT 'draft',
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `notes` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quotations`
--

LOCK TABLES `quotations` WRITE;
/*!40000 ALTER TABLE `quotations` DISABLE KEYS */;
/*!40000 ALTER TABLE `quotations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role_has_permissions`
--

DROP TABLE IF EXISTS `role_has_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `role_has_permissions` (
  `permission_id` bigint(20) unsigned NOT NULL,
  `role_id` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`permission_id`,`role_id`),
  KEY `role_has_permissions_role_id_foreign` (`role_id`),
  CONSTRAINT `role_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `role_has_permissions_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role_has_permissions`
--

LOCK TABLES `role_has_permissions` WRITE;
/*!40000 ALTER TABLE `role_has_permissions` DISABLE KEYS */;
INSERT INTO `role_has_permissions` VALUES
(1,1),
(2,1),
(3,1),
(4,1),
(5,1),
(6,1),
(7,1),
(8,1),
(9,1),
(10,1),
(11,1),
(12,1),
(13,1),
(14,1),
(15,1),
(16,1),
(17,1),
(18,1),
(19,1),
(20,1),
(21,1),
(22,1),
(23,1),
(24,1),
(25,1),
(26,1),
(27,1),
(28,1),
(29,1),
(30,1),
(31,1),
(32,1),
(33,1),
(34,1);
/*!40000 ALTER TABLE `role_has_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `roles` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `display_name` varchar(255) DEFAULT NULL,
  `guard_name` varchar(255) NOT NULL,
  `company_id` int(11) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `roles_name_guard_name_company_id_unique` (`name`,`guard_name`,`company_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES
(1,'SUPER_ADMIN','Super Admin','web',0,'2024-11-25 11:18:09','2024-11-25 11:18:09'),
(2,'ADMIN','Admin','web',0,'2024-11-25 11:18:09','2024-11-25 11:18:09');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `room_types`
--

DROP TABLE IF EXISTS `room_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `room_types` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `accommodation_type` varchar(255) NOT NULL,
  `max_adults` int(11) NOT NULL DEFAULT 0,
  `max_childs` int(11) NOT NULL DEFAULT 0,
  `max_occupancy` int(11) NOT NULL DEFAULT 0,
  `price_per_night` double(8,2) NOT NULL DEFAULT 0.00,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `room_types`
--

LOCK TABLES `room_types` WRITE;
/*!40000 ALTER TABLE `room_types` DISABLE KEYS */;
/*!40000 ALTER TABLE `room_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rooms`
--

DROP TABLE IF EXISTS `rooms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rooms` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `room_type_id` int(10) unsigned NOT NULL,
  `room_no` varchar(255) NOT NULL,
  `floor_no` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `rooms_room_no_unique` (`room_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rooms`
--

LOCK TABLES `rooms` WRITE;
/*!40000 ALTER TABLE `rooms` DISABLE KEYS */;
/*!40000 ALTER TABLE `rooms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rooms_bookings`
--

DROP TABLE IF EXISTS `rooms_bookings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rooms_bookings` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `room_booking_id` bigint(20) unsigned NOT NULL,
  `room_id` bigint(20) unsigned NOT NULL,
  `check_in` timestamp NULL DEFAULT NULL,
  `check_out` timestamp NULL DEFAULT NULL,
  `price_per_night` double(8,2) NOT NULL DEFAULT 0.00,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rooms_bookings`
--

LOCK TABLES `rooms_bookings` WRITE;
/*!40000 ALTER TABLE `rooms_bookings` DISABLE KEYS */;
/*!40000 ALTER TABLE `rooms_bookings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `supplier_payments`
--

DROP TABLE IF EXISTS `supplier_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `supplier_payments` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `date` date NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `supplier_id` bigint(20) unsigned NOT NULL,
  `payment_method` varchar(255) DEFAULT NULL,
  `code` varchar(255) DEFAULT NULL,
  `note` varchar(60) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `supplier_payments_code_unique` (`code`),
  KEY `supplier_payments_supplier_id_foreign` (`supplier_id`),
  CONSTRAINT `supplier_payments_supplier_id_foreign` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `supplier_payments`
--

LOCK TABLES `supplier_payments` WRITE;
/*!40000 ALTER TABLE `supplier_payments` DISABLE KEYS */;
/*!40000 ALTER TABLE `supplier_payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `suppliers`
--

DROP TABLE IF EXISTS `suppliers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `suppliers` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `code` varchar(255) NOT NULL,
  `created_by` int(10) unsigned DEFAULT NULL,
  `updated_by` int(10) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `suppliers_code_unique` (`code`),
  UNIQUE KEY `suppliers_email_unique` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `suppliers`
--

LOCK TABLES `suppliers` WRITE;
/*!40000 ALTER TABLE `suppliers` DISABLE KEYS */;
/*!40000 ALTER TABLE `suppliers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `company_id` bigint(20) unsigned DEFAULT NULL,
  `is_owner` tinyint(1) NOT NULL DEFAULT 0,
  `is_super_admin` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES
(1,'Admin','admin@pramixit.com','2024-11-25 11:18:09','$2y$10$3DTUEsDJRclSHM3vaB.5GeDFjZdiNyxFZFAENBrdWX9KyckeY2ola',NULL,'2024-11-25 11:18:09','2024-11-25 11:18:09',1,1,1),
(2,'Sandakelum Priyamantha Wijewardhana','sandakelum.1dev@gmail.com',NULL,'$2y$10$YYbQUCo8.Q58ZTGoDw/.buMCv.lUh/2LMGhg3RpOKDyHZP0O3SPJe','7LEnavPgeEH7w8QsavZsKwAF2dzoq4PIaClAoBjAfuxt4OGaLhtsqd9nA65C','2024-11-27 23:28:12','2024-11-27 23:29:13',2,1,0),
(3,'sandakelum priyamantha','sandakelum.dev2@gmail.com',NULL,'$2y$10$6ikNKio.1xWO1RJVpD/4z.3cM9anvjaucemFXcCzcvKw9umG1P9/G',NULL,'2024-12-03 02:56:49','2024-12-03 02:57:19',3,1,0),
(4,'sandakelum priyamantha','sandakelum.dev@gmail.com',NULL,'$2y$10$vlPZnQPWt9yysseIxDhOGOrgnmrSVBSiHtTfY4F324Ci/fgqkGofe',NULL,'2024-12-03 03:04:04','2024-12-03 03:04:27',4,1,0),
(5,'Sandakelum Priyamantha Wijewardhana','sandakelum1.dev@gmail.com',NULL,'$2y$10$40VHtJsRMqxSfzTezVH./u.pMu7u3G89CszaHaOm2dUAKK0EK5iA.',NULL,'2024-12-29 10:37:54','2024-12-29 10:38:33',5,1,0);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-01-06  6:42:38
