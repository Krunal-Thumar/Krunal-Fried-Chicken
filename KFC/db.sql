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
	(1, 'Fried Chicken Bucket', 15.00, 'https://media.istockphoto.com/id/1396896459/photo/chicken-fried-bugket-isolated-on-white-background.jpg?s=612x612&w=0&k=20&c=hW6_BeRY93n3-I94ZjqWCesTct0ZTdGtzvSh_IPHLyE='),
	(2, 'Spicy Wings', 10.00, 'https://www.thespicehouse.com/cdn/shop/articles/Insane_Hot_Wings_720x.jpg?v=1588270427'),
	(3, 'Chicken Sandwich', 8.00, 'https://static01.nyt.com/images/2021/07/06/dining/yk-muhammara-chicken-sandwiches/merlin_189026502_58171dd4-b0bc-47c3-aa6a-d910a3f1de4c-superJumbo.jpg'),
	(4, 'French Fries', 5.00, 'https://upload.wikimedia.org/wikipedia/commons/8/83/French_Fries.JPG'),
	(5, 'Chicken Tenders', 7.00, 'https://www.allrecipes.com/thmb/YwJvX75IUx8uQ7PKz2eTDjCoLvY=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/16669-fried-chicken-tenders-DDMFS-4x3-219f03b885be40139c8d93bef21d0a50.jpg'),
  (6, 'Mozzarella Sticks', 6.00, 'https://images.themodernproper.com/billowy-turkey/production/posts/2021/Homemade-Mozzarella-Sticks-9.jpeg?w=960&h=960&q=82&fm=jpg&fit=crop&dm=1638935116&s=2574b8da89d966ee167111e9822a0b4e'),
	(7, 'Onion Rings', 5.50, 'https://img.buzzfeed.com/thumbnailer-prod-us-east-1/7f539fc41a5543aebfe03afed73a0b48/BFV9112_MozzarellaStickOnionRings.jpg'),
	(8, 'Grilled Chicken Salad', 9.00, 'https://hips.hearstapps.com/hmg-prod/images/grilled-chicken-salad-lead-6628169550105.jpg'),
	(9, 'Cheeseburger', 12.00, 'https://www.sargento.com/assets/Uploads/Recipe/Image/burger_0.jpg'),
	(10, 'Veggie Wrap', 7.50, 'https://eatplant-based.com/wp-content/uploads/2014/12/Veggie-Wraps.jpg'),
	(11, 'Garlic Bread', 4.00, 'https://www.allrecipes.com/thmb/ymrjQ3GFq_Fc7Fu2yfvIj108tcM=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/21080-great-garlic-bread-DDMFS-4x3-e1c7b5c79fde4d629a9b7bce6c0702ed.jpg'),
	(12, 'Chocolate Milkshake', 5.50, 'https://jordanseasyentertaining.com/wp-content/uploads/2015/06/chocolate-peanut-butter-milkshake-recipe.jpg'),
	(13, 'Buffalo Wings', 11.00, 'https://www.kitchensanctuary.com/wp-content/uploads/2019/09/Buffalo-Wings-square-FS-55.jpg'),
	(14, 'Caesar Salad', 8.00, 'https://natashaskitchen.com/wp-content/uploads/2019/01/Caesar-Salad-Recipe-3.jpg'),
	(15, 'Mac and Cheese', 6.50, 'https://www.southernliving.com/thmb/sB-5HNqjc-vtM8WdPZLed5tIpmE=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/southern-living-cajun-mac-and-cheese-3x2-59-4215f98c65174f2d8a5a27fd9e589adc.jpg'),
	(16, 'Taco Bowl', 10.00, 'https://thebigmansworld.com/wp-content/uploads/2024/03/taco-bowl-recipe.jpg'),
	(17, 'Chocolate Cake Slice', 4.50, 'https://iambaker.net/wp-content/uploads/2013/11/chocolate-cake-slice-e1562794545746.jpg'),
	(18, "100k Users' credit card information", 5.00, 'https://gravitypayments.com/wp-content/uploads/2023/11/shutterstock_287890574.jpg'),
	(19, 'Pepperoni Pizza Slice', 3.50, 'https://img.freepik.com/premium-photo/slice-pizza-with-pepperoni-it_848191-121.jpg'),
	(20, 'Pineapple Pizza (The best type of pizza)', 69.99, 'https://www.welshitalianpizza.com/wp-content/uploads/2024/04/DALL%C2%B7E-2024-04-17-15.13.10-A-realistic-photo-of-a-pizza-topped-with-an-unusually-large-whole-pineapple-sitting-in-the-center.-The-pizza-should-have-a-golden-brown-crust-melted.webp');

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