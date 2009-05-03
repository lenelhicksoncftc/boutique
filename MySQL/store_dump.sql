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
  KEY `phone` (`phone`),
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
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;



# Dump of table products
# ------------------------------------------------------------

CREATE TABLE `products` (
  `id` varchar(15) CHARACTER SET utf8 NOT NULL,
  `name` varchar(30) CHARACTER SET utf8 NOT NULL,
  `description` varchar(60) CHARACTER SET utf8 NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `publicKey` varchar(512) COLLATE utf8_bin NOT NULL,
  `privateKey` varchar(512) COLLATE utf8_bin NOT NULL,
  UNIQUE KEY `item` (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;



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
  `paymentDate` date NOT NULL,
  `paymentStatus` varchar(15) COLLATE utf8_bin DEFAULT NULL,
  `paymentType` varchar(15) COLLATE utf8_bin DEFAULT NULL,
  `type` varchar(15) COLLATE utf8_bin DEFAULT NULL,
  `currency` varchar(8) CHARACTER SET utf8 NOT NULL,
  `gross` decimal(10,2) DEFAULT NULL,
  `fee` decimal(10,2) DEFAULT NULL,
  `receiptId` varchar(40) CHARACTER SET utf8 DEFAULT NULL,
  `parentTransactionId` varchar(40) CHARACTER SET utf8 DEFAULT NULL,
  `errorCode` int(11) DEFAULT NULL,
  `couponId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `contactId` (`contactId`),
  KEY `paymentDate` (`paymentDate`),
  KEY `receiptId` (`receiptId`)
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

