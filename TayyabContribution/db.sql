-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               11.5.2-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             12.6.0.6765
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for krunal_fried_chicken_db
CREATE DATABASE IF NOT EXISTS `krunal_fried_chicken_db` /*!40100 DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci */;
USE `krunal_fried_chicken_db`;

-- Dumping structure for table krunal_fried_chicken_db.addresses
CREATE TABLE IF NOT EXISTS `addresses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `address` varchar(255) NOT NULL,
  `city` varchar(100) DEFAULT NULL,
  `country` varchar(100) DEFAULT NULL,
  `zip_code` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `addresses_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Dumping data for table krunal_fried_chicken_db.addresses: ~1 rows (approximately)
DELETE FROM `addresses`;
INSERT INTO `addresses` (`id`, `user_id`, `address`, `city`, `country`, `zip_code`) VALUES
	(1, 1, 'Dubai', 'DSO', NULL, NULL);

-- Dumping structure for table krunal_fried_chicken_db.orders
CREATE TABLE IF NOT EXISTS `orders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `order_date` timestamp NULL DEFAULT current_timestamp(),
  `delivery_address` varchar(255) NOT NULL,
  `payment_method` enum('cash','card') NOT NULL,
  `status` enum('pending','delivered') DEFAULT 'pending',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Dumping data for table krunal_fried_chicken_db.orders: ~0 rows (approximately)
DELETE FROM `orders`;

-- Dumping structure for table krunal_fried_chicken_db.products
CREATE TABLE IF NOT EXISTS `products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `price` decimal(5,2) NOT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Dumping data for table krunal_fried_chicken_db.products: ~5 rows (approximately)
DELETE FROM `products`;
INSERT INTO `products` (`id`, `name`, `price`, `image_url`) VALUES
	(1, 'Fried Chicken Bucket', 15.00, 'https://media.istockphoto.com/id/1396896459/photo/chicken-fried-bugket-isolated-on-white-background.jpg?s=612x612&w=0&k=20&c=hW6_BeRY93n3-I94ZjqWCesTct0ZTdGtzvSh_IPHLyE='),
	(2, 'Spicy Wings', 10.00, 'https://www.thespicehouse.com/cdn/shop/articles/Insane_Hot_Wings_720x.jpg?v=1588270427'),
	(3, 'Chicken Sandwich', 8.00, 'https://static01.nyt.com/images/2021/07/06/dining/yk-muhammara-chicken-sandwiches/merlin_189026502_58171dd4-b0bc-47c3-aa6a-d910a3f1de4c-superJumbo.jpg'),
	(4, 'French Fries', 5.00, 'https://upload.wikimedia.org/wikipedia/commons/8/83/French_Fries.JPG'),
	(5, 'Chicken Tenders', 7.00, 'https://www.allrecipes.com/thmb/YwJvX75IUx8uQ7PKz2eTDjCoLvY=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/16669-fried-chicken-tenders-DDMFS-4x3-219f03b885be40139c8d93bef21d0a50.jpg');

-- Dumping structure for table krunal_fried_chicken_db.users
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Dumping data for table krunal_fried_chicken_db.users: ~5 rows (approximately)
DELETE FROM `users`;
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `password`) VALUES
	(1, 'Omar', 'Jammoul', 'omar@kfc.com', '$2b$10$1VWH.TChNm0whWEXzKTZmuXO8btqKzt2fdRVvARC5Zp/woq.LK/GW'),
	(2, 'Khalifa', NULL, 'khalifa@KFC.com', '$2b$10$WZ3MVLeg0J2ZviLjOyssz.8GgORHGjll2N7tUrnRPml0.DYLcX7Xq'),
	(3, 'Krunal', NULL, 'krunal@KFC.com', '$2b$10$zcB6uYEHjL48FLDPg5QpQOn9nKt/G5XsItb0NAmyImZvFyyNUfkuy'),
	(4, 'Tayyab', NULL, 'tayyab@KFC.com', '$2b$10$ISCmUb0/YL4/QpWr0JfNBus/LbiPolTUr2iGyvNVSiWKQPPBriB8C'),
	(5, 'Admin', NULL, 'admin@KFC.com', '$2b$10$skoHUfmJA.4om.uNYHYyh.8tCltLFom2oGQt.5/CqeP3D3Qv93aRS');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
