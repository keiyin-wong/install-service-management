/*
SQLyog Community v13.1.9 (64 bit)
MySQL - 10.3.34-MariaDB-0ubuntu0.20.04.1 : Database - installation_service
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`installation_service` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `installation_service`;

/*Table structure for table `order` */

DROP TABLE IF EXISTS `order`;

CREATE TABLE `order` (
  `id` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `date` date DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `order` */

insert  into `order`(`id`,`date`) values 
('12951','2022-05-01'),
('19568','2022-06-01'),
('19578','2022-06-04'),
('19583','2022-06-03'),
('19584','2022-07-19'),
('19585','2022-07-08'),
('19586','2022-07-10'),
('19587','2022-07-10'),
('19588','2022-07-10'),
('19589','2022-07-10'),
('19590','2022-07-28'),
('19591','2022-07-28'),
('19592','2022-07-28'),
('19593','2022-07-28'),
('19594','2022-07-28');

/*Table structure for table `order_detail` */

DROP TABLE IF EXISTS `order_detail`;

CREATE TABLE `order_detail` (
  `order_id` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `line_number` bigint(20) NOT NULL,
  `service_id` bigint(20) DEFAULT NULL,
  `description` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `width` double DEFAULT 0,
  `height` double DEFAULT 0,
  `quantity` bigint(20) DEFAULT 0,
  `final_price` bigint(20) NOT NULL COMMENT 'in sens',
  PRIMARY KEY (`order_id`,`line_number`),
  KEY `order_detail_ibfk_1` (`service_id`),
  CONSTRAINT `order_detail_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `order` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `order_detail_ibfk_2` FOREIGN KEY (`service_id`) REFERENCES `service` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `order_detail` */

insert  into `order_detail`(`order_id`,`line_number`,`service_id`,`description`,`width`,`height`,`quantity`,`final_price`) values 
('12951',1,4,'',3333,900,1,5000),
('12951',2,3,'',1300,200,0,2000),
('12951',3,1,'',1234,123,0,2000),
('12951',4,1,'',234,233,0,2003),
('19583',1,1,'',1233,3000,0,2000),
('19583',2,4,'',0,0,333,5000),
('19583',3,3,'',3,3,0,2000),
('19584',1,2,'33',334,3333,0,2000),
('19584',5,4,'Testing 1',0,0,12,90000),
('19584',6,3,'',123,333,0,2000),
('19585',1,2,'',5666,3,0,2000),
('19586',1,1,'',1234,1233,0,3000),
('19586',2,4,'',0,0,12,5000),
('19586',3,4,'',0,0,3,5000),
('19586',4,3,'',4500,3222,0,2000),
('19586',5,1,'',3200,1233,0,3000),
('19586',6,4,'',0,0,1,5000),
('19586',7,4,'',0,0,1,5000),
('19586',8,4,'',0,0,1,5000),
('19586',9,4,'',0,0,1,5000),
('19586',10,4,'',0,0,1,5000),
('19586',11,4,'',0,0,3,5000),
('19586',12,4,'',0,0,4,5000),
('19586',13,4,'',0,0,3,5000),
('19586',14,4,'',0,0,4,5000),
('19586',15,3,'你搞',12355,23,0,2000),
('19586',16,4,'',0,0,123,5000),
('19586',17,4,'',0,0,3,5000),
('19586',18,4,'',0,0,5,5000),
('19586',19,4,'',0,0,3,5000),
('19586',20,4,'',0,0,12,5000),
('19594',1,1,'',1234,132,0,2000);

/*Table structure for table `service` */

DROP TABLE IF EXISTS `service`;

CREATE TABLE `service` (
  `id` bigint(20) NOT NULL,
  `description_english` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description_chinese` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `price` bigint(20) DEFAULT NULL,
  `is_different_price` tinyint(1) DEFAULT NULL,
  `use_quantity` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `service` */

insert  into `service`(`id`,`description_english`,`description_chinese`,`price`,`is_different_price`,`use_quantity`) values 
(1,'wall unit','上座柜',2000,1,0),
(2,'base unit','下座柜',2000,0,0),
(3,'concrete top b/unit','石犀桌',2000,0,0),
(4,'tv cabinet & dressing table','',5000,0,1);

/*Table structure for table `service_diff_price` */

DROP TABLE IF EXISTS `service_diff_price`;

CREATE TABLE `service_diff_price` (
  `service_id` bigint(20) NOT NULL,
  `height` double NOT NULL,
  `price` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`service_id`,`height`),
  CONSTRAINT `service_diff_price_ibfk_1` FOREIGN KEY (`service_id`) REFERENCES `service` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='value above\r\n';

/*Data for the table `service_diff_price` */

insert  into `service_diff_price`(`service_id`,`height`,`price`) values 
(1,700,2000),
(1,800,2200),
(1,900,2400),
(1,1000,2600),
(1,1100,2800),
(1,1200,3000),
(1,1300,3200),
(1,1400,4000),
(1,1500,4200),
(1,1600,4600),
(1,1700,4800);

/*Table structure for table `user_roles` */

DROP TABLE IF EXISTS `user_roles`;

CREATE TABLE `user_roles` (
  `user_role_id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(45) DEFAULT NULL,
  `role` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`user_role_id`),
  UNIQUE KEY `uni_username_role` (`role`,`username`),
  KEY `user_roles_ibfk_1` (`username`),
  CONSTRAINT `user_roles_ibfk_1` FOREIGN KEY (`username`) REFERENCES `users` (`username`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

/*Data for the table `user_roles` */

insert  into `user_roles`(`user_role_id`,`username`,`role`) values 
(5,'admin','ROLE_ADMIN'),
(4,'admin','ROLE_USER'),
(2,'wahshoon','ROLE_USER');

/*Table structure for table `users` */

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `username` varchar(45) NOT NULL,
  `password` varchar(45) DEFAULT NULL,
  `enabled` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `users` */

insert  into `users`(`username`,`password`,`enabled`) values 
('admin','admin1234',1),
('wahshoon','wahshoon',1);

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
