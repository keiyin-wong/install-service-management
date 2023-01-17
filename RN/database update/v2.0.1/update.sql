CREATE TABLE `system_parameter` (
  `id` BIGINT(13) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `description` VARCHAR(500) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  `value` TEXT CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=INNODB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `system_parameter` (`id`, `name`, `description`, `value`) VALUES('1','COMPANY_NAME','company name, used in invoice','WAH SHOON ENTERPRISE');
INSERT INTO `system_parameter` (`id`, `name`, `description`, `value`) VALUES('2','COMPANY_ADDRESS','company address','1C-00-13, Jalan Wawasan 5/4,\r\nPusat Bandar Puchong,\r\n47160 Puchong,\r\nSelangor');
INSERT INTO `system_parameter` (`id`, `name`, `description`, `value`) VALUES('3','COMPANY_PHONE','company phone number','0174857507');
INSERT INTO `system_parameter` (`id`, `name`, `description`, `value`) VALUES ('4', 'TERMS_AND_CONDITIONS', 'term and condition', 'Thank you for your business!'); 


ALTER TABLE `order` ADD COLUMN `remarks` TEXT NOT NULL COMMENT 'Will be shown in invoice' DEFAULT "";
ALTER TABLE `order` ADD COLUMN `comments` TEXT NOT NULL COMMENT 'For internal use only' DEFAULT "";
