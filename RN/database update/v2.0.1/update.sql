CREATE TABLE `system_parameter` (
  `id` bigint(13) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `description` varchar(500) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  `value` text CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_c

insert into `system_parameter` (`id`, `name`, `description`, `value`) values('1','COMPANY_NAME','company name, used in invoice','WAH SHOON ENTERPRISE');
insert into `system_parameter` (`id`, `name`, `description`, `value`) values('2','COMPANY_ADDRESS','company address','1C-00-13, Jalan Wawasan 5/4,\r\nPusat Bandar Puchong,\r\n47160 Puchong,\r\nSelangor');
insert into `system_parameter` (`id`, `name`, `description`, `value`) values('3','COMPANY_PHONE','company phone number','0174857507');
