-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 13, 2023 at 01:21 AM
-- Server version: 10.4.27-MariaDB
-- PHP Version: 8.2.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `general_db`
--
CREATE DATABASE IF NOT EXISTS `general_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `general_db`;

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE IF NOT EXISTS `user` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `Username` varchar(255) NOT NULL,
  `Password` varchar(255) NOT NULL,
  `Type` enum('super','admin') NOT NULL,
  `Revoked` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------
--
-- Table structure for table `bons`
--

CREATE TABLE IF NOT EXISTS `bon` (
  `bon_id` int(11) NOT NULL AUTO_INCREMENT,
  `Date` date NOT NULL,
  `Provider_id` int(11) NOT NULL,
  `Reduction` decimal(10,2) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`bon_id`),
  KEY `user_id` (`user_id`),
  KEY `Provider_id`(`Provider_id`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `bon_product` (
  `bon_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `Quantity` int(11) NOT NULL,
  `price`  decimal(50,2) NOT NULL,
  KEY `bon_id` (`bon_id`) ,
  KEY `product_id` (`product_id`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- --------------------------------------------------------

-- Table structure for table `history_bon`

CREATE TABLE IF NOT EXISTS `history_bon`(
  `bon_id` int(11) NOT NULL, 
  `Date` date NOT NULL,
  `user_id` int(11) NOT NULL,
  KEY `user_id` (`user_id`),
  KEY `bon_id` (`bon_id`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- --------------------------------------------------------

-- Table structure for table `client`


CREATE TABLE IF NOT EXISTS `client` (
  `client_id` int(11) NOT NULL AUTO_INCREMENT,
  `name_client` varchar(64) NOT NULL,
  `phone_client` varchar(64) NOT NULL,
  PRIMARY KEY (`client_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

-- Table structure for table `facture`
--

CREATE TABLE IF NOT EXISTS `facture` (
  `facture_id` int(11) NOT NULL AUTO_INCREMENT,
  `facture_name` varchar(255) NOT NULL,
  `Reduction` decimal(10,2) DEFAULT NULL,
  `Sorti` tinyint(1) DEFAULT NULL,
  `Brouillon` tinyint(1) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `client_id` int(11) NOT NULL,
   PRIMARY KEY (`facture_id`),
   KEY `user_id` (`user_id`),
   KEY `client_id` (`client_id`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- --------------------------------------------------------

-- Table structure for table `history_facture`
--

CREATE Table IF NOT EXISTS `history_facture`(
  `facture_id` int(11) NOT NULL,
  `Date` date NOT NULL,
  `user_id` int(11) NOT NULL,
  KEY `user_id` (`user_id`),
  KEY `facture_id` (`facture_id`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------
-- Table structure for table `factures_product`
--

CREATE TABLE IF NOT EXISTS `facture_product` (
  `facture_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `Quantity` int(11) NOT NULL,
   KEY `facture_id` (`facture_id`), 
   KEY `product_id` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------
--
-- Table structure for table `transactions`
--

CREATE TABLE IF NOT EXISTS `transactions` (
  `transaction_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `Amount` decimal(20,2) NOT NULL,
  `Date` date NOT NULL,
  `Description` text NOT NULL,
  `Transaction_type` enum('money_in','money_out') DEFAULT NULL,
  `Destination` enum('cashier','coffre','switch') DEFAULT NULL,
  PRIMARY KEY (`transaction_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------
--
-- Table structure for table `product`
--

CREATE TABLE IF NOT EXISTS `product` (
  `product_id` int(11) NOT NULL AUTO_INCREMENT,
  `product_name` varchar(255) NOT NULL,
  `price` decimal(50,2) NOT NULL,
  `Quantity` int(11) NOT NULL,
  `Photo_file_name` varchar(255) DEFAULT NULL,
  `hidden` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `history_product`
--
CREATE TABLE IF NOT EXISTS `history_product`(
  `product_id` int(11) NOT NULL ,
  `product_previous_name` varchar(255) NOT NULL,
  `previous_price` decimal(50,2) NOT NULL,
  `user_id` int(11) NOT NULL,
  KEY (`product_id`),
  KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- ---------------------------------------------------------
--
-- Table structure for table `providers`
--

CREATE TABLE IF NOT EXISTS `provider` (
  `provider_id` int(11) NOT NULL AUTO_INCREMENT,
  `provider_name` varchar(255) NOT NULL,
  `provider_phone` varchar(255) NOT NULL,
  `Company_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`provider_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


 -- Modification: Created new table fees


-- --------------------------------------------------------
--
-- Table structure for table `versements`
--

CREATE TABLE IF NOT EXISTS `versement` (
  `versement_id` int(11) NOT NULL AUTO_INCREMENT,
  `facture_id`   int(11) NOT NULL,
  
  `amount` decimal(10,2) DEFAULT NULL,
  `date` date DEFAULT NULL,
  
  `Description` text DEFAULT NULL,
  PRIMARY KEY (`versement_id`),
  KEY `facture_id` (`facture_id`)
  
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `versement_bon` (
  `bon_id` int(11) NOT NULL,
  `versement_id` int(11) NOT NULL,
  `Date` date NOT NULL,
  KEY `bon_id` (`bon_id`) ,
  KEY `product_id` (`versement_id`) 
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci; 

CREATE TABLE IF NOT EXISTS `caisse` (
  `caisse_id` int(11) NOT NULL AUTO_INCREMENT,
  `amount_coffer` DECIMAL(10, 2),
  PRIMARY KEY (`caisse_id`)

)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `coffer` (
  `coffer_id` int(11) NOT NULL AUTO_INCREMENT,
  `amount_caisse` DECIMAL(10, 2),
  PRIMARY KEY (`coffer_id`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Modification: Created new table versement_bon

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bons`
--
ALTER TABLE `bon`
  ADD CONSTRAINT `bon_ibfk_1` FOREIGN KEY (`provider_id`) REFERENCES `provider` (`provider_id`),
  ADD CONSTRAINT `bon_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`);

--
-- Constraints for table `history_bon`
--

ALTER TABLE `history_product`
ADD CONSTRAINT `history_product_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `product` (`product_id`),
ADD CONSTRAINT `history_product_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`);


--
-- Constraints for table `bon_product`
--

ALTER Table `bon_product`

  ADD CONSTRAINT `bon_products_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `product` (`product_id`),
  ADD CONSTRAINT `bon_products_ibfk_2` FOREIGN KEY (`bon_id`) REFERENCES `bon` (`bon_id`);


--
-- Constraints for table `factures`
--
ALTER TABLE `facture`
  ADD CONSTRAINT `facture_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`),
  ADD CONSTRAINT `facture_ibfk_2` FOREIGN KEY (`client_id`) REFERENCES `client` (`client_id`);


--
-- Constraints for table `factures_products`
--
ALTER TABLE `facture_product`
  ADD CONSTRAINT `facture_product_ibfk_1` FOREIGN KEY (`facture_id`) REFERENCES `facture` (`facture_id`),
  ADD CONSTRAINT `facture_product_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `product` (`product_id`);


--
-- Constraints for table `history_facture`
--
ALTER TABLE `history_facture`
  ADD CONSTRAINT `history_facture_ibfk_1` FOREIGN KEY (`facture_id`) REFERENCES `facture` (`facture_id`),
  ADD CONSTRAINT `history_facture_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`);

--
-- Constraints for table `transactions`
--
ALTER TABLE `transactions`
  ADD CONSTRAINT `transactions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`);

--
-- Constraints for table `versements`
--
ALTER TABLE `versement`
  ADD CONSTRAINT `versements_ibfk_1` FOREIGN KEY (`facture_id`) REFERENCES `facture` (`facture_id`);
COMMIT;

ALTER TABLE `facture`
ADD `sum` DECIMAL(10,2); -- Modification: Added sum column

ALTER TABLE `facture_product`
ADD `PU` DECIMAL(10,2); -- Modification: Added PU column

ALTER Table `versement_bon`

  ADD CONSTRAINT `versement_bon_ibfk_2` FOREIGN KEY (`bon_id`) REFERENCES `bon` (`bon_id`);

ALTER TABLE facture_product
ADD composite_product_ids VARCHAR(255) DEFAULT NULL;







/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
