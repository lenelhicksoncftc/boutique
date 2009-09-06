# Sequel Pro dump
# Version 254
# http://code.google.com/p/sequel-pro
#
# Host: 127.0.0.1 (MySQL 5.1.34-log)
# Database: store
# Generation Time: 2009-05-02 21:43:25 -0600
# ************************************************************

# Dump of table contacts
# ------------------------------------------------------------

CREATE TABLE `contacts` (
  `id` varchar(40) CHARACTER SET utf8 NOT NULL,
  `firstName` varchar(40) CHARACTER SET utf8 DEFAULT NULL,
  `lastName` varchar(40) CHARACTER SET utf8 DEFAULT NULL,
  `company` varchar(40) CHARACTER SET utf8 DEFAULT NULL,
  `address` varchar(40) CHARACTER SET utf8 DEFAULT NULL,
  `address2` varchar(40) CHARACTER SET utf8 DEFAULT NULL,
  `city` varchar(30) CHARACTER SET utf8 DEFAULT NULL,
  `state` varchar(30) CHARACTER SET utf8 DEFAULT NULL,
  `zip` varchar(20) CHARACTER SET utf8 NOT NULL,
  `country` varchar(30) CHARACTER SET utf8 DEFAULT NULL,
  `phone` varchar(30) CHARACTER SET utf8 DEFAULT NULL,
  `email` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
  `website` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `email` (`email`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;



# Dump of table coupons
# ------------------------------------------------------------

CREATE TABLE `coupons` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(20) NOT NULL,
  `productId` int(11) DEFAULT NULL,
  `startDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `endDate` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `value` float NOT NULL,
  `type` varchar(3) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT '0',
  `used` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `code` (`code`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;



# Dump of table products
# ------------------------------------------------------------

CREATE TABLE `products` (
  `id` varchar(15) CHARACTER SET utf8 NOT NULL,
  `name` varchar(30) CHARACTER SET utf8 NOT NULL,
  `description` varchar(60) COLLATE utf8_bin DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `publicKey` varchar(512) COLLATE utf8_bin NOT NULL,
  `privateKey` varchar(512) COLLATE utf8_bin NOT NULL,
  `currency` varchar(5) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

INSERT INTO `products` (`id`,`name`,`description`,`price`,`publicKey`,`privateKey`,`currency`)
VALUES
	(1,'Demo',NULL,8.99,'AA6C2C8BDFFE238FD5611C8CF6A56250C0723850FE87483FA8B30EFAE7690004B06B286E77C15927796354968EA9905D9933AFCDBACBAC9E6B90A6E8F069B9BECDDD95165C88CFBABE828967A3B495CC2F3A6B6124D640822C19B37DC7DC85244928C66676F98D037D2375529245D6C8D787434409139B1A24D1F3A781964A91','719D7307EAA96D0A8E40BDB34F18EC35D5A17AE0A9AF857FC5CCB4A744F0AAADCAF21AF44FD63B6FA64238645F1BB593BB77CA892732731447B5C49B4AF1267E1D682C33A846A006FB8C8338BCE909CD51FC2C1AE9B53E0E10ADCECB13D0002E3320B8D1E277647FF5D2B43FCC6045C582954DBC678488B918F44C0FA2012543','USD');



# Dump of table requests
# ------------------------------------------------------------

CREATE TABLE `requests` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `transactionId` varchar(40) COLLATE utf8_bin NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `duringSale` tinyint(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;



# Dump of table transactions
# ------------------------------------------------------------

CREATE TABLE `transactions` (
  `id` varchar(40) CHARACTER SET utf8 NOT NULL,
  `paypalTransactionId` varchar(40) COLLATE utf8_bin DEFAULT NULL,
  `contactId` varchar(40) CHARACTER SET utf8 NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT '1',
  `item` varchar(15) CHARACTER SET utf8 NOT NULL,
  `description` varchar(30) CHARACTER SET utf8 NOT NULL,
  `paymentDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `paymentStatus` varchar(15) COLLATE utf8_bin DEFAULT NULL,
  `paymentType` varchar(15) COLLATE utf8_bin DEFAULT NULL,
  `type` varchar(15) COLLATE utf8_bin DEFAULT NULL,
  `currency` varchar(8) CHARACTER SET utf8 NOT NULL,
  `gross` decimal(10,2) DEFAULT NULL,
  `refund` decimal(10,2) DEFAULT '0.00',
  `fee` decimal(10,2) DEFAULT NULL,
  `receiptId` varchar(40) CHARACTER SET utf8 DEFAULT NULL,
  `parentTransactionId` varchar(40) CHARACTER SET utf8 DEFAULT NULL,
  `errorCode` int(11) DEFAULT NULL,
  `couponId` int(11) DEFAULT NULL,
  `revoked` tinyint(4) DEFAULT '0',
  PRIMARY KEY  (`id`),
  KEY `contactId` (`contactId`),
  KEY `paymentDate` (`paymentDate`),
  KEY `item` (`item`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;



# Dump of table users
# ------------------------------------------------------------

CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(40) DEFAULT NULL,
  `password` varchar(50) DEFAULT NULL,
  `active_flag` int(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

INSERT INTO `users` (`id`,`username`,`password`,`active_flag`)
VALUES
	(1,'admin',PASSWORD('changeme'),1);

