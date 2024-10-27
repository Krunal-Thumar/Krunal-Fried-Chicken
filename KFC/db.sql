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

-- Dumping data for table krunal_fried_chicken_db.addresses: ~0 rows (approximately)
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

CREATE TABLE cards (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    cardholder_name VARCHAR(100) NOT NULL,
    card_number VARCHAR(100) NOT NULL,
    expiry_date VARCHAR(100) NOT NULL,  -- Format MM/YY
    cvv VARCHAR(100) NOT NULL,


    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Dumping data for table krunal_fried_chicken_db.products:
DELETE FROM `products`;
INSERT INTO `products` (`id`, `name`, `price`, `image_url`) VALUES
(1, 'Loaded Twister Spicy', 12.00, 'https://kfcprodimages-ehcsdud6a5a5eqcm.z01.azurefd.net/cmsimages/kfc/uae/desktop/imagestemp/115008.png'),
(2, 'Loaded Twister Original', 12.00, 'https://kfcprodimages-ehcsdud6a5a5eqcm.z01.azurefd.net/cmsimages/kfc/uae/desktop/imagestemp/115009.png'),
(3, 'Veggie Zinger', 9.00, 'https://kfcprodimages-ehcsdud6a5a5eqcm.z01.azurefd.net/cmsimages/kfc/uae/desktop/imagestemp/110037.png'),
(4, 'Kentucky Sandwich - Spicy', 3.50, 'https://kfcprodimages-ehcsdud6a5a5eqcm.z01.azurefd.net/cmsimages/kfc/egy/desktop/imagestemp/110061.png'),
(5, 'Zinger Sandwich', 18.00, 'https://kfcprodimages-ehcsdud6a5a5eqcm.z01.azurefd.net/cmsimages/kfc/uae/desktop/imagestemp/972-Combo.png'),
(6, 'Fillet Supreme', 20.00, 'https://kfcprodimages-ehcsdud6a5a5eqcm.z01.azurefd.net/cmsimages/kfc/uae/desktop/imagestemp/110008.png'),
(7, 'Dynamite Cruncher', 9.00, 'https://kfcprodimages-ehcsdud6a5a5eqcm.z01.azurefd.net/cmsimages/kfc/uae/desktop/imagestemp/110058.png'),
(8, 'Pepper Mayo Cruncher', 9.00, 'https://kfcprodimages-ehcsdud6a5a5eqcm.z01.azurefd.net/cmsimages/kfc/uae/desktop/imagestemp/110060.png'),
(9, 'Onion Rings', 11.00, 'https://kfcprodimages-ehcsdud6a5a5eqcm.z01.azurefd.net/cmsimages/kfc/uae/desktop/imagestemp/5000461.png'),
(10, 'Twister Box', 31.00, 'https://kfcprodimages-ehcsdud6a5a5eqcm.z01.azurefd.net/cmsimages/kfc/ksa/desktop/imagestemp/23-Combo.png'),
(11, 'Zinger Box', 41.00, 'https://kfcprodimages-ehcsdud6a5a5eqcm.z01.azurefd.net/cmsimages/kfc/ksa/desktop/imagestemp/29-Combo.png'),
(12, 'Dynamite Wings', 26.50, 'https://kfcprodimages-ehcsdud6a5a5eqcm.z01.azurefd.net/cmsimages/kfc/ksa/desktop/imagestemp/221-Combo.png'),
(13, 'Wings Meal', 26.50, 'https://kfcprodimages-ehcsdud6a5a5eqcm.z01.azurefd.net/cmsimages/kfc/ksa/desktop/imagestemp/223-Combo.png'),
(14, 'Twister Max Combo', 32.00, 'https://kfcprodimages-ehcsdud6a5a5eqcm.z01.azurefd.net/cmsimages/kfc/bhr/desktop/imagestemp/149-Combo.png'),
(15, 'Big Filler Box', 39.00, 'https://kfcprodimages-ehcsdud6a5a5eqcm.z01.azurefd.net/cmsimages/kfc/qat/desktop/imagestemp/472-Combo.png'),
(16, 'Mix Mania', 78.50, 'https://kfcprodimages-ehcsdud6a5a5eqcm.z01.azurefd.net/cmsimages/kfc/kwt/desktop/imagestemp/642-Combo.png'),
(17, 'Big Filler Jalapeno Combo', 32.00, 'https://kfcprodimages-ehcsdud6a5a5eqcm.z01.azurefd.net/cmsimages/kfc/qat/desktop/imagestemp/454-Combo.png'),
(18, 'Spicy Fries', 11.00, 'https://kfcprodimages-ehcsdud6a5a5eqcm.z01.azurefd.net/cmsimages/kfc/uae/desktop/imagestemp/5000082.png'),
(19, '3 Pcs Hot Lime Wings', 9.00, 'https://kfcprodimages-ehcsdud6a5a5eqcm.z01.azurefd.net/cmsimages/kfc/uae/desktop/imagestemp/510101.png'),
(20, 'My Dipping Bucket', 88.00, 'https://kfcprodimages-ehcsdud6a5a5eqcm.z01.azurefd.net/cmsimages/kfc/ksa/desktop/imagestemp/430-Combo.png'),
(21, 'Regular Loaded Fries Pepper Chili', 4.00, 'https://kfcprodimages-ehcsdud6a5a5eqcm.z01.azurefd.net/cmsimages/kfc/omn/desktop/imagestemp/510079.png'),
(22, 'Harissa Sauce', 2.00, 'https://kfcprodimages-ehcsdud6a5a5eqcm.z01.azurefd.net/cmsimages/kfc/omn/desktop/imagestemp/810037.png'),
(23, 'Dynamite Sauce', 2.50, 'https://kfcprodimages-ehcsdud6a5a5eqcm.z01.azurefd.net/cmsimages/kfc/omn/desktop/imagestemp/810028.png'),
(24, 'Cheetos Sauce', 2.50, 'https://kfcprodimages-ehcsdud6a5a5eqcm.z01.azurefd.net/cmsimages/kfc/ksa/desktop/imagestemp/810061.png'),
(25, 'BBQ Sauce', 2.50, 'https://kfcprodimages-ehcsdud6a5a5eqcm.z01.azurefd.net/cmsimages/kfc/omn/desktop/imagestemp/810042.png'),
(26, 'Cheddar Sauce', 2.00, 'https://kfcprodimages-ehcsdud6a5a5eqcm.z01.azurefd.net/cmsimages/kfc/omn/desktop/imagestemp/813002.png'),
(27, 'Colonel Signature Sauce', 2.50, 'https://kfcprodimages-ehcsdud6a5a5eqcm.z01.azurefd.net/cmsimages/kfc/omn/desktop/imagestemp/810040.png'),
(28, 'Garlic Buttermilk Sauce', 2.50, 'https://kfcprodimages-ehcsdud6a5a5eqcm.z01.azurefd.net/cmsimages/kfc/omn/desktop/imagestemp/810041.png'),
(29, 'Sweet Chili Sauce', 2.50, 'https://kfcprodimages-ehcsdud6a5a5eqcm.z01.azurefd.net/cmsimages/kfc/omn/desktop/imagestemp/816003.png'),
(30, 'Kentucky Ranch Sauce', 2.50, 'https://kfcprodimages-ehcsdud6a5a5eqcm.z01.azurefd.net/cmsimages/kfc/kwt/desktop/imagestemp/810040.png'),
(31, 'Mojito Krushers', 8.50, 'https://kfcprodimages-ehcsdud6a5a5eqcm.z01.azurefd.net/cmsimages/kfc/omn/desktop/imagestemp/610021.png'),
(32, 'Magic Mojito', 8.50, 'https://kfcprodimages-ehcsdud6a5a5eqcm.z01.azurefd.net/cmsimages/kfc/omn/desktop/imagestemp/610013.png'),
(33, 'Small Water', 3.00, 'https://kfcprodimages-ehcsdud6a5a5eqcm.z01.azurefd.net/cmsimages/kfc/bhr/desktop/imagestemp/618012.png'),
(34, 'Orange Juice', 6.00, 'https://kfcprodimages-ehcsdud6a5a5eqcm.z01.azurefd.net/cmsimages/kfc/jor/desktop/imagestemp/100012.png'),
(35, 'Dipper Fries', 11.00, 'https://kfcprodimages-ehcsdud6a5a5eqcm.z01.azurefd.net/cmsimages/kfc/kwt/desktop/imagestemp/213.png'),
(36, 'Coleslaw', 7.00, 'https://kfcprodimages-ehcsdud6a5a5eqcm.z01.azurefd.net/cmsimages/kfc/ksa/desktop/imagestemp/21.png'),
(37, 'Rice', 22.00, 'https://kfcprodimages-ehcsdud6a5a5eqcm.z01.azurefd.net/cmsimages/kfc/jor/desktop/imagestemp/510025.png'),
(38, 'Cookie', 3.00, 'https://kfcprodimages-ehcsdud6a5a5eqcm.z01.azurefd.net/cmsimages/kfc/egy/desktop/imagestemp/710003.png'),
(39, 'Bun', 1.00, 'https://kfcprodimages-ehcsdud6a5a5eqcm.z01.azurefd.net/cmsimages/kfc/ksa/desktop/imagestemp/810002.png');

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
	(1, 'admin', null, 'admin@kfc.com', '21232f297a57a5a743894a0e4a801fc3');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;