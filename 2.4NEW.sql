-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               5.7.18-log - MySQL Community Server (GPL)
-- Server OS:                    Win64
-- HeidiSQL Version:             9.4.0.5125
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Dumping database structure for gta5_gamemode_essential
CREATE DATABASE IF NOT EXISTS `gta5_gamemode_essential` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `gta5_gamemode_essential`;

-- Dumping structure for table gta5_gamemode_essential.autoecole
CREATE TABLE IF NOT EXISTS `autoecole` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `vehicle` varchar(255) NOT NULL,
  `end_x` decimal(65,3) NOT NULL,
  `end_y` decimal(65,3) NOT NULL,
  `end_z` decimal(65,3) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- Dumping data for table gta5_gamemode_essential.autoecole: ~4 rows (approximately)
/*!40000 ALTER TABLE `autoecole` DISABLE KEYS */;
INSERT INTO `autoecole` (`id`, `name`, `vehicle`, `end_x`, `end_y`, `end_z`) VALUES
	(1, 'Driving Licence', 'blista', 141.180, 6634.790, 31.636),
	(2, 'Motorcycle licence', 'akuma', 646.875, 584.900, 128.911),
	(3, 'Cycling License (bsr)', 'fixter', -2316.720, 428.935, 174.467),
	(4, 'Heavy Truck Licenses', 'pounder', 1268.240, -3186.820, 5.903);
/*!40000 ALTER TABLE `autoecole` ENABLE KEYS */;

-- Dumping structure for table gta5_gamemode_essential.backpack
CREATE TABLE IF NOT EXISTS `backpack` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(60) NOT NULL,
  `weight` bigint(255) DEFAULT NULL,
  `price` int(225) NOT NULL DEFAULT '0',
  `prop` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

-- Dumping data for table gta5_gamemode_essential.backpack: ~4 rows (approximately)
/*!40000 ALTER TABLE `backpack` DISABLE KEYS */;
INSERT INTO `backpack` (`id`, `name`, `weight`, `price`, `prop`) VALUES
	(1, 'Pocket', 12000, 0, '0'),
	(2, 'Small bag', 24000, 100000, '31'),
	(3, 'Medium bag', 48000, 500000, '41'),
	(4, 'Large bag', 72000, 1000000, '45');
/*!40000 ALTER TABLE `backpack` ENABLE KEYS */;

-- Dumping structure for table gta5_gamemode_essential.bans
CREATE TABLE IF NOT EXISTS `bans` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `banned` varchar(50) NOT NULL DEFAULT '0',
  `banner` varchar(50) NOT NULL,
  `reason` varchar(150) NOT NULL DEFAULT '0',
  `expires` datetime NOT NULL,
  `timestamp` datetime NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=181 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- Dumping data for table gta5_gamemode_essential.bans: ~0 rows (approximately)
/*!40000 ALTER TABLE `bans` DISABLE KEYS */;
/*!40000 ALTER TABLE `bans` ENABLE KEYS */;

-- Dumping structure for table gta5_gamemode_essential.clothes
CREATE TABLE IF NOT EXISTS `clothes` (
  `identifier` varchar(50) DEFAULT NULL,
  `model` varchar(30) CHARACTER SET utf8 NOT NULL DEFAULT 'ig_barry',
  `head` int(11) NOT NULL DEFAULT '0',
  `mask` int(11) NOT NULL DEFAULT '0',
  `hair` int(11) NOT NULL DEFAULT '0',
  `hand` int(11) NOT NULL DEFAULT '0',
  `pants` int(11) NOT NULL DEFAULT '0',
  `gloves` int(11) NOT NULL DEFAULT '0',
  `shoes` int(11) NOT NULL DEFAULT '0',
  `eyes` int(11) NOT NULL DEFAULT '0',
  `accessories` int(11) NOT NULL DEFAULT '0',
  `items` int(11) NOT NULL DEFAULT '0',
  `decals` int(11) NOT NULL DEFAULT '0',
  `shirts` int(11) NOT NULL DEFAULT '0',
  `helmet` int(11) NOT NULL DEFAULT '0',
  `glasses` int(11) NOT NULL DEFAULT '0',
  `earrings` int(11) NOT NULL DEFAULT '0',
  `beard` int(11) NOT NULL DEFAULT '0',
  `eyebrow` int(11) NOT NULL DEFAULT '0',
  `makeup` int(11) NOT NULL DEFAULT '0',
  `lipstick` int(11) NOT NULL DEFAULT '0',
  `mask_txt` int(11) NOT NULL DEFAULT '0',
  `hair_txt` int(11) NOT NULL DEFAULT '0',
  `pants_txt` int(11) NOT NULL DEFAULT '0',
  `gloves_txt` int(11) NOT NULL DEFAULT '0',
  `shoes_txt` int(11) NOT NULL DEFAULT '0',
  `eyes_txt` int(11) NOT NULL DEFAULT '0',
  `accessories_txt` int(11) NOT NULL DEFAULT '0',
  `items_txt` int(11) NOT NULL DEFAULT '0',
  `decals_txt` int(11) NOT NULL DEFAULT '0',
  `shirts_txt` int(11) NOT NULL DEFAULT '0',
  `helmet_txt` int(11) NOT NULL DEFAULT '0',
  `glasses_txt` int(11) NOT NULL DEFAULT '0',
  `earrings_txt` int(11) NOT NULL DEFAULT '0',
  `hand_txt` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table gta5_gamemode_essential.clothes: ~2 rows (approximately)
/*!40000 ALTER TABLE `clothes` DISABLE KEYS */;
INSERT INTO `clothes` (`identifier`, `model`, `head`, `mask`, `hair`, `hand`, `pants`, `gloves`, `shoes`, `eyes`, `accessories`, `items`, `decals`, `shirts`, `helmet`, `glasses`, `earrings`, `beard`, `eyebrow`, `makeup`, `lipstick`, `mask_txt`, `hair_txt`, `pants_txt`, `gloves_txt`, `shoes_txt`, `eyes_txt`, `accessories_txt`, `items_txt`, `decals_txt`, `shirts_txt`, `helmet_txt`, `glasses_txt`, `earrings_txt`, `hand_txt`) VALUES
	('steam:110000107aff8a1', 'a_m_m_indian_01', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, -1, -1, -1, -1, -1, -1, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, -1, -1, 0, 1),
	('steam:1100001047596ec', 'a_m_m_tranvest_01', 1, 0, 3, 1, 1, 1, 0, 0, 1, 0, 0, 0, -1, -1, -1, -1, -1, -1, -1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, -1, -1, 0, 0);
/*!40000 ALTER TABLE `clothes` ENABLE KEYS */;

-- Dumping structure for table gta5_gamemode_essential.dmv
CREATE TABLE IF NOT EXISTS `dmv` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `identifier` varchar(45) NOT NULL DEFAULT '',
  `valid` varchar(45) NOT NULL DEFAULT 'no',
  `marks` varchar(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=223 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- Dumping data for table gta5_gamemode_essential.dmv: ~0 rows (approximately)
/*!40000 ALTER TABLE `dmv` DISABLE KEYS */;
/*!40000 ALTER TABLE `dmv` ENABLE KEYS */;

-- Dumping structure for table gta5_gamemode_essential.ems
CREATE TABLE IF NOT EXISTS `ems` (
  `job_id` int(11) NOT NULL AUTO_INCREMENT,
  `job_name` varchar(40) NOT NULL,
  `salary` int(11) NOT NULL DEFAULT '500',
  PRIMARY KEY (`job_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;

-- Dumping data for table gta5_gamemode_essential.ems: ~0 rows (approximately)
/*!40000 ALTER TABLE `ems` DISABLE KEYS */;
INSERT INTO `ems` (`job_id`, `job_name`, `salary`) VALUES
	(11, 'ambulance', 500);
/*!40000 ALTER TABLE `ems` ENABLE KEYS */;

-- Dumping structure for table gta5_gamemode_essential.garages
CREATE TABLE IF NOT EXISTS `garages` (
  `id` int(255) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `x` decimal(10,2) NOT NULL,
  `y` decimal(10,2) NOT NULL,
  `z` decimal(10,2) NOT NULL,
  `price` int(11) NOT NULL,
  `blip_colour` int(255) NOT NULL,
  `blip_id` int(255) NOT NULL,
  `slot` int(255) NOT NULL,
  `available` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8;

-- Dumping data for table gta5_gamemode_essential.garages: ~22 rows (approximately)
/*!40000 ALTER TABLE `garages` DISABLE KEYS */;
INSERT INTO `garages` (`id`, `name`, `x`, `y`, `z`, `price`, `blip_colour`, `blip_id`, `slot`, `available`) VALUES
	(1, 'GreenWich 1', -1087.14, -2232.71, 12.23, 120000, 3, 369, 10, 'on'),
	(2, 'GreenWich 2', -1096.78, -2222.89, 12.23, 120000, 3, 369, 10, 'on'),
	(3, 'Exceptionalists 1', -666.51, -2379.42, 12.89, 120000, 3, 369, 10, 'on'),
	(4, 'Exceptionalists 2', -673.16, -2391.26, 12.90, 120000, 3, 369, 10, 'on'),
	(5, 'South Shambles', 1027.35, -2398.38, 28.87, 120000, 3, 369, 10, 'on'),
	(6, 'Olympic Freeway 1', -221.11, -1162.51, 22.02, 120000, 3, 369, 10, 'on'),
	(7, 'Olympic Freeway 2', -41.88, -1235.24, 28.38, 25000, 3, 369, 2, 'on'),
	(8, 'Olympic Freeway 3', -41.79, -1242.01, 28.34, 25000, 3, 369, 2, 'on'),
	(9, 'Olympic Freeway 4', -42.16, -1252.35, 28.27, 25000, 3, 369, 2, 'on'),
	(10, 'Olympic Fury', 841.65, -1162.91, 24.27, 70000, 3, 369, 6, 'on'),
	(11, 'Murrieta Heights 1', 964.78, -1031.05, 39.84, 150000, 3, 369, 10, 'on'),
	(12, 'Murrieta Heights 2', 964.77, -1025.43, 39.85, 150000, 3, 369, 10, 'on'),
	(13, 'Murrieta Heights 3', 964.75, -1019.79, 39.85, 150000, 3, 369, 10, 'on'),
	(14, 'Murrieta Heights 4', 964.70, -1014.04, 39.85, 150000, 3, 369, 10, 'on'),
	(15, 'Popular Street 1', 815.13, -923.22, 25.14, 200000, 3, 369, 15, 'on'),
	(16, 'Popular Street 2', 819.65, -922.89, 25.12, 200000, 3, 369, 15, 'on'),
	(17, 'Golden Garages', -791.74, 333.14, 84.70, 1500000, 3, 369, 99, 'off'),
	(18, 'Joshua Road', 190.31, 2787.02, 44.61, 60000, 3, 369, 6, 'on'),
	(19, 'Route 68 1', 639.22, 2773.21, 41.02, 30000, 3, 369, 2, 'on'),
	(20, 'Route 68 2', 644.25, 2791.79, 40.95, 30000, 3, 369, 2, 'on'),
	(21, 'Paleto Blvd', -244.24, 6238.69, 30.49, 35000, 3, 369, 2, 'on'),
	(22, 'Public Garage', -332.99, -779.03, 32.72, 0, 3, 357, 1, 'on');
/*!40000 ALTER TABLE `garages` ENABLE KEYS */;

-- Dumping structure for table gta5_gamemode_essential.interiors
CREATE TABLE IF NOT EXISTS `interiors` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'key id',
  `enter` text NOT NULL COMMENT 'enter coords',
  `exit` text NOT NULL COMMENT 'destination coords',
  `iname` text NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- Dumping data for table gta5_gamemode_essential.interiors: ~0 rows (approximately)
/*!40000 ALTER TABLE `interiors` DISABLE KEYS */;
INSERT INTO `interiors` (`id`, `enter`, `exit`, `iname`) VALUES
	(1, '{-1388.24,-586.854,30.2176,90}', '{-1387.61,-588.068,30.3195,90}', 'Mamas');
/*!40000 ALTER TABLE `interiors` ENABLE KEYS */;

-- Dumping structure for table gta5_gamemode_essential.items
CREATE TABLE IF NOT EXISTS `items` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `pre_id` int(11) DEFAULT NULL,
  `weight` int(255) DEFAULT NULL,
  `ratio` int(60) DEFAULT NULL,
  `need` int(255) DEFAULT NULL,
  `price` int(60) DEFAULT NULL,
  `value` int(255) DEFAULT '0',
  `type` int(255) DEFAULT '0',
  `craft` int(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8;

-- Dumping data for table gta5_gamemode_essential.items: ~18 rows (approximately)
/*!40000 ALTER TABLE `items` DISABLE KEYS */;
INSERT INTO `items` (`id`, `name`, `pre_id`, `weight`, `ratio`, `need`, `price`, `value`, `type`, `craft`) VALUES
	(1, 'Canabis plant', 0, 600, 1, 0, 20, 0, 5, 1),
	(2, 'Canabis heads', 1, 40, 6, 1, 25, 0, 5, 1),
	(4, 'Water Bottle', 0, 450, 1, 0, 30, 50, 10, 0),
	(5, 'Energy bar', 0, 200, 1, 0, 15, 20, 10, 0),
	(6, 'Ore (copper)', 0, 1000, 1, 0, 5, 0, 0, 2),
	(7, 'Ingot (copper)', 6, 1000, 1, 2, 225, 0, 0, 2),
	(8, 'Repair kit', 0, 8000, 1, 0, 500, 0, 3, 0),
	(9, 'Coca plant', 0, 600, 1, 0, 20, 0, 5, 1),
	(10, 'Coca leaves', 9, 40, 6, 1, 45, 0, 5, 1),
	(11, 'Ore (gold)', 0, 1000, 1, 0, 25, 0, 0, 2),
	(12, 'Ingot (gold)', 12, 1000, 1, 2, 385, 0, 0, 2),
	(13, 'LockPick', 0, 50, 1, 0, 250, 0, 4, 0),
	(20, 'Orange', 0, 200, 1, 0, 1, 15, 0, 1),
	(21, 'Orange juice', 20, 1000, 1, 10, 5, 30, 0, 1),
	(22, 'Clone Creditcard Data', 0, 600, 1, 0, 100, 0, 0, 1),
	(23, 'Creditcard Clone', 22, 600, 1, 1, 1100, 0, 0, 1),
	(24, 'Energy Drink', 0, 650, 1, 0, 45, 70, 10, 0),
	(25, 'Beef jerkey', 0, 350, 1, 0, 48, 70, 10, 0);
/*!40000 ALTER TABLE `items` ENABLE KEYS */;

-- Dumping structure for table gta5_gamemode_essential.jobs
CREATE TABLE IF NOT EXISTS `jobs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `job_name` varchar(40) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- Dumping data for table gta5_gamemode_essential.jobs: ~3 rows (approximately)
/*!40000 ALTER TABLE `jobs` DISABLE KEYS */;
INSERT INTO `jobs` (`id`, `job_name`) VALUES
	(1, 'Miner (copper)'),
	(2, 'Miner (gold)'),
	(3, 'Unemployed');
/*!40000 ALTER TABLE `jobs` ENABLE KEYS */;

-- Dumping structure for table gta5_gamemode_essential.jobs_nem
CREATE TABLE IF NOT EXISTS `jobs_nem` (
  `job_id` int(11) NOT NULL AUTO_INCREMENT,
  `job_name` varchar(40) NOT NULL,
  `salary` int(11) NOT NULL DEFAULT '500',
  PRIMARY KEY (`job_id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8;

-- Dumping data for table gta5_gamemode_essential.jobs_nem: ~4 rows (approximately)
/*!40000 ALTER TABLE `jobs_nem` DISABLE KEYS */;
INSERT INTO `jobs_nem` (`job_id`, `job_name`, `salary`) VALUES
	(1, 'Unemplyed', 500),
	(15, 'ambulancier', 500),
	(16, 'mecano', 500),
	(17, 'Taxi', 500);
/*!40000 ALTER TABLE `jobs_nem` ENABLE KEYS */;

-- Dumping structure for table gta5_gamemode_essential.jobs_ressources
CREATE TABLE IF NOT EXISTS `jobs_ressources` (
  `id_ressources` int(11) NOT NULL AUTO_INCREMENT,
  `job_id` int(255) DEFAULT NULL,
  `job_name` varchar(255) DEFAULT NULL,
  `action` varchar(255) DEFAULT NULL,
  `bname` varchar(255) DEFAULT NULL,
  `item_id` int(255) DEFAULT NULL,
  `blip_colour` int(255) DEFAULT NULL,
  `blip_id` int(255) DEFAULT NULL,
  `x` decimal(10,2) DEFAULT NULL,
  `y` decimal(10,2) DEFAULT NULL,
  `z` decimal(10,2) DEFAULT NULL,
  `time` int(255) DEFAULT NULL,
  `hide` varchar(255) DEFAULT NULL,
  `vehicle_model` varchar(255) DEFAULT NULL,
  `vehicle_cost` int(255) DEFAULT NULL,
  `vehicle_capacity` int(255) DEFAULT NULL,
  PRIMARY KEY (`id_ressources`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

-- Dumping data for table gta5_gamemode_essential.jobs_ressources: ~8 rows (approximately)
/*!40000 ALTER TABLE `jobs_ressources` DISABLE KEYS */;
INSERT INTO `jobs_ressources` (`id_ressources`, `job_id`, `job_name`, `action`, `bname`, `item_id`, `blip_colour`, `blip_id`, `x`, `y`, `z`, `time`, `hide`, `vehicle_model`, `vehicle_cost`, `vehicle_capacity`) VALUES
	(1, 1, 'Miner (copper)', 'warehouse', 'Vehicle Depot (copper)', 6, 17, 67, 481.92, -1977.27, 23.48, 300000, 'on', 'Rubble', 1000, 40000),
	(2, 1, 'Miner (copper)', 'harvest', 'Mine (copper)', 6, 17, 89, 2946.82, 2804.02, 41.37, 3000, 'on', 'Rubble', 1000, 40000),
	(3, 1, 'Miner (copper)', 'treatment', 'Treatment (copper)', 7, 17, 79, 312.39, 2872.32, 43.51, 3000, 'on', 'Rubble', 1000, 40000),
	(4, 1, 'Miner (copper)', 'sell', 'Sale (copper)', 7, 17, 108, -114.42, -1050.48, 27.27, 3000, 'on', 'Rubble', 1000, 40000),
	(5, 2, 'Miner (gold)', 'warehouse', 'Vehicle Depot (gold)', 11, 46, 67, 815.71, 2185.12, 51.20, 300000, 'on', 'Rubble', 1000, 40000),
	(6, 2, 'Miner (gold)', 'harvest', 'Mine (gold)', 11, 46, 89, -605.21, 2104.57, 127.82, 300000, 'on', 'Rubble', 1000, 40000),
	(7, 2, 'Miner (gold)', 'treatment', 'Treatment (gold)', 12, 46, 79, 82.21, 6323.33, 31.24, 300000, 'on', 'Rubble', 1000, 40000),
	(8, 2, 'Miner (gold)', 'sell', 'Sale (gold)', 12, 46, 108, -635.64, -240.29, 38.10, 300000, 'on', 'Rubble', 1000, 40000);
/*!40000 ALTER TABLE `jobs_ressources` ENABLE KEYS */;

-- Dumping structure for table gta5_gamemode_essential.licences
CREATE TABLE IF NOT EXISTS `licences` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `price` int(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- Dumping data for table gta5_gamemode_essential.licences: ~2 rows (approximately)
/*!40000 ALTER TABLE `licences` DISABLE KEYS */;
INSERT INTO `licences` (`id`, `name`, `price`) VALUES
	(1, 'Driving Licence', 1000),
	(2, 'Weapon Licence', 5000);
/*!40000 ALTER TABLE `licences` ENABLE KEYS */;

-- Dumping structure for table gta5_gamemode_essential.loadouts
CREATE TABLE IF NOT EXISTS `loadouts` (
  `identifier` varchar(256) NOT NULL COMMENT 'The player''s identifier',
  `loadout_name` varchar(256) NOT NULL COMMENT 'The loadout they currently have',
  `hair` int(11) NOT NULL,
  `haircolour` int(11) NOT NULL,
  `torso` int(11) NOT NULL,
  `torsotexture` int(11) NOT NULL,
  `torsoextra` int(11) NOT NULL,
  `torsoextratexture` int(11) NOT NULL,
  `pants` int(11) NOT NULL,
  `pantscolour` int(11) NOT NULL,
  `shoes` int(11) NOT NULL,
  `shoescolour` int(11) NOT NULL,
  `bodyaccessory` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- Dumping data for table gta5_gamemode_essential.loadouts: ~0 rows (approximately)
/*!40000 ALTER TABLE `loadouts` DISABLE KEYS */;
/*!40000 ALTER TABLE `loadouts` ENABLE KEYS */;

-- Dumping structure for table gta5_gamemode_essential.npcs
CREATE TABLE IF NOT EXISTS `npcs` (
  `idnpcs` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL DEFAULT '',
  `busy` varchar(45) NOT NULL DEFAULT '',
  `engagedWith` varchar(45) NOT NULL DEFAULT '',
  PRIMARY KEY (`idnpcs`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- Dumping data for table gta5_gamemode_essential.npcs: ~0 rows (approximately)
/*!40000 ALTER TABLE `npcs` DISABLE KEYS */;
/*!40000 ALTER TABLE `npcs` ENABLE KEYS */;

-- Dumping structure for table gta5_gamemode_essential.outfits
CREATE TABLE IF NOT EXISTS `outfits` (
  `identifier` varchar(30) NOT NULL,
  `skin` varchar(30) CHARACTER SET utf8 NOT NULL DEFAULT 'mp_m_freemode_01',
  `face` int(11) NOT NULL DEFAULT '0',
  `face_text` int(11) NOT NULL DEFAULT '0',
  `hair` int(11) NOT NULL DEFAULT '0',
  `hair_text` int(11) NOT NULL DEFAULT '0',
  `pants` int(11) NOT NULL DEFAULT '0',
  `pants_text` int(11) NOT NULL DEFAULT '0',
  `shoes` int(11) NOT NULL DEFAULT '0',
  `shoes_text` int(11) NOT NULL DEFAULT '0',
  `torso` int(11) NOT NULL DEFAULT '0',
  `torso_text` int(11) NOT NULL DEFAULT '0',
  `shirt` int(11) NOT NULL DEFAULT '0',
  `shirt_text` int(11) NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- Dumping data for table gta5_gamemode_essential.outfits: 0 rows
/*!40000 ALTER TABLE `outfits` DISABLE KEYS */;
/*!40000 ALTER TABLE `outfits` ENABLE KEYS */;

-- Dumping structure for table gta5_gamemode_essential.owned
CREATE TABLE IF NOT EXISTS `owned` (
  `identifier` varchar(50) DEFAULT NULL,
  `weapon` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- Dumping data for table gta5_gamemode_essential.owned: ~0 rows (approximately)
/*!40000 ALTER TABLE `owned` DISABLE KEYS */;
/*!40000 ALTER TABLE `owned` ENABLE KEYS */;

-- Dumping structure for table gta5_gamemode_essential.phone_messages
CREATE TABLE IF NOT EXISTS `phone_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `transmitter` varchar(10) NOT NULL,
  `receiver` varchar(10) NOT NULL,
  `message` varchar(255) NOT NULL DEFAULT '0',
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `isRead` int(11) NOT NULL DEFAULT '0',
  `owner` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table gta5_gamemode_essential.phone_messages: ~0 rows (approximately)
/*!40000 ALTER TABLE `phone_messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_messages` ENABLE KEYS */;

-- Dumping structure for table gta5_gamemode_essential.phone_users_contacts
CREATE TABLE IF NOT EXISTS `phone_users_contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(255) NOT NULL,
  `number` varchar(10) NOT NULL,
  `display` varchar(64) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- Dumping data for table gta5_gamemode_essential.phone_users_contacts: ~0 rows (approximately)
/*!40000 ALTER TABLE `phone_users_contacts` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_users_contacts` ENABLE KEYS */;

-- Dumping structure for table gta5_gamemode_essential.police
CREATE TABLE IF NOT EXISTS `police` (
  `identifier` varchar(255) NOT NULL,
  `rank` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`identifier`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- Dumping data for table gta5_gamemode_essential.police: ~0 rows (approximately)
/*!40000 ALTER TABLE `police` DISABLE KEYS */;
/*!40000 ALTER TABLE `police` ENABLE KEYS */;

-- Dumping structure for table gta5_gamemode_essential.president
CREATE TABLE IF NOT EXISTS `president` (
  `identifier` varchar(255) NOT NULL,
  `rankpres` varchar(255) NOT NULL DEFAULT 'President',
  PRIMARY KEY (`identifier`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- Dumping data for table gta5_gamemode_essential.president: ~0 rows (approximately)
/*!40000 ALTER TABLE `president` DISABLE KEYS */;
/*!40000 ALTER TABLE `president` ENABLE KEYS */;

-- Dumping structure for table gta5_gamemode_essential.ressources
CREATE TABLE IF NOT EXISTS `ressources` (
  `id_ressources` int(11) NOT NULL AUTO_INCREMENT,
  `action` varchar(255) DEFAULT NULL,
  `bname` varchar(255) DEFAULT NULL,
  `item_id` int(255) DEFAULT NULL,
  `blip_colour` int(255) DEFAULT NULL,
  `blip_id` int(255) DEFAULT NULL,
  `x` decimal(10,2) DEFAULT NULL,
  `y` decimal(10,2) DEFAULT NULL,
  `z` decimal(10,2) DEFAULT NULL,
  `time` int(255) DEFAULT NULL,
  `hide` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_ressources`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8;

-- Dumping data for table gta5_gamemode_essential.ressources: ~12 rows (approximately)
/*!40000 ALTER TABLE `ressources` DISABLE KEYS */;
INSERT INTO `ressources` (`id_ressources`, `action`, `bname`, `item_id`, `blip_colour`, `blip_id`, `x`, `y`, `z`, `time`, `hide`) VALUES
	(1, 'harvest', 'Harvest of oranges', 20, 47, 1, 2003.19, 4787.08, 41.80, 5000, 'on'),
	(4, 'harvest', 'Canabis plant', 1, 25, 1, 8000.00, 5576.96, 53.82, 5000, 'off'),
	(5, 'treatment', 'Canabis treatment', 2, 25, 1, 2193.59, 5595.09, 53.76, 5000, 'off'),
	(6, 'treatment', 'Orange juice factory', 21, 47, 1, 1979.02, 5171.45, 46.64, 5000, 'on'),
	(7, 'sell', 'Canabis sell', 2, 25, 1, -1161.14, -1568.15, 4.40, 5000, 'off'),
	(8, 'sell', 'Sell orange juice', 21, 47, 1, 2240.45, 5159.58, 56.83, 5000, 'on'),
	(11, 'harvest', 'Coke plant', 9, 25, 1, 1209.81, -3121.37, 5.54, 5000, 'off'),
	(12, 'treatment', 'Coke leaves treat', 10, 25, 1, 705.83, -961.12, 30.40, 5000, 'off'),
	(13, 'sell', 'Coke leaves sell', 10, 25, 1, -572.51, 286.42, 79.18, 5000, 'off'),
	(14, 'harvest', 'Cloning Creditcard Data', 22, 69, 1, -165.61, -303.84, 39.77, 5000, 'off'),
	(15, 'treatment', 'Creditcard Clone', 23, 69, 1, 1275.65, -1710.33, 54.77, 5000, 'off'),
	(16, 'sell', 'Max Creditcard', 23, 69, 1, -95.13, 6457.54, 31.46, 5000, 'off');
/*!40000 ALTER TABLE `ressources` ENABLE KEYS */;

-- Dumping structure for table gta5_gamemode_essential.turfs
CREATE TABLE IF NOT EXISTS `turfs` (
  `identifier` varchar(50) DEFAULT NULL,
  `SANDY` tinyint(4) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- Dumping data for table gta5_gamemode_essential.turfs: ~0 rows (approximately)
/*!40000 ALTER TABLE `turfs` DISABLE KEYS */;
/*!40000 ALTER TABLE `turfs` ENABLE KEYS */;

-- Dumping structure for table gta5_gamemode_essential.users
CREATE TABLE IF NOT EXISTS `users` (
  `identifier` varchar(255) CHARACTER SET utf8mb4 NOT NULL DEFAULT '',
  `skin` varchar(35) NOT NULL DEFAULT 'a_m_y_skater_01',
  `groupz` varchar(50) NOT NULL DEFAULT '0',
  `permission_level` int(11) NOT NULL DEFAULT '0',
  `money` double NOT NULL DEFAULT '0',
  `vehicle` varchar(45) NOT NULL DEFAULT 'none',
  `tow` varchar(45) NOT NULL DEFAULT '',
  `bankbalance` int(32) DEFAULT '0',
  `isFirstConnection` int(11) DEFAULT '1',
  `nom` varchar(50) DEFAULT NULL,
  `lastpos` varchar(255) DEFAULT '{138.321, -767.649, 45.752, 69.442}',
  `enService` tinyint(1) NOT NULL DEFAULT '0',
  `personalvehicle` varchar(55) DEFAULT NULL,
  `question_rp` varchar(50) NOT NULL DEFAULT 'false',
  `player_state` int(255) NOT NULL DEFAULT '0',
  `job` int(11) DEFAULT '1',
  `job_id` int(225) DEFAULT NULL,
  `job_vehicle_plate` varchar(225) NOT NULL DEFAULT 'vierge',
  `job_vehicle_model` varchar(225) NOT NULL DEFAULT 'vierge',
  `job_service` varchar(225) NOT NULL DEFAULT 'off',
  `backpack_id` int(225) NOT NULL DEFAULT '1',
  `spawnpointx` varchar(191) NOT NULL DEFAULT '0',
  `spawnpointy` varchar(191) NOT NULL DEFAULT '0',
  `spawnpointz` varchar(191) NOT NULL DEFAULT '0',
  `weapon` varchar(45) NOT NULL DEFAULT '0xA2719263',
  `weapon2` varchar(45) NOT NULL DEFAULT '',
  `weapon3` varchar(45) NOT NULL DEFAULT '',
  `model` varchar(45) NOT NULL DEFAULT '',
  `drug` varchar(45) NOT NULL DEFAULT '',
  `playtime` double NOT NULL DEFAULT '0',
  `shotsfired` double NOT NULL DEFAULT '0',
  `kmdriven` double NOT NULL DEFAULT '0',
  `phone_number` varchar(50) DEFAULT '0',
  `prenom` varchar(128) NOT NULL DEFAULT '',
  `dateNaissance` date DEFAULT '1980-01-01',
  `sexe` varchar(1) NOT NULL DEFAULT 'f',
  `taille` int(10) unsigned NOT NULL DEFAULT '0',
  `vip` int(10) unsigned NOT NULL DEFAULT '2',
  `DmvTest` varchar(50) NOT NULL DEFAULT 'Required',
  PRIMARY KEY (`identifier`,`tow`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- Dumping data for table gta5_gamemode_essential.users: ~1 rows (approximately)
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` (`identifier`, `skin`, `groupz`, `permission_level`, `money`, `vehicle`, `tow`, `bankbalance`, `isFirstConnection`, `nom`, `lastpos`, `enService`, `personalvehicle`, `question_rp`, `player_state`, `job`, `job_id`, `job_vehicle_plate`, `job_vehicle_model`, `job_service`, `backpack_id`, `spawnpointx`, `spawnpointy`, `spawnpointz`, `weapon`, `weapon2`, `weapon3`, `model`, `drug`, `playtime`, `shotsfired`, `kmdriven`, `phone_number`, `prenom`, `dateNaissance`, `sexe`, `taille`, `vip`, `DmvTest`) VALUES
	('steam:1100001047596ec', 'a_m_y_skater_01', 'user', 0, 5000, 'none', '', 0, 1, 'May Silvers', '{-94.4551010131836, -707.428100585938,  34.3709411621094, 72.6539611816406}', 0, NULL, 'false', 0, 1, NULL, 'vierge', 'vierge', 'off', 1, '0', '0', '0', '0xA2719263', '', '', '', '', 0, 0, 0, '0709251818', 'May', '1916-07-06', 'f', 150, 2, 'Required'),
	('steam:110000107aff8a1', 'a_m_y_skater_01', 'owner', 1000, 7150980, 'none', '', 0, 0, 'Doofy Gilmore', '{3037.79150390625, -4615.51708984375,  15.261438369751, 200.000061035156}', 0, 'exemplar', 'false', 0, 16, NULL, 'vierge', 'vierge', 'off', 1, '0', '0', '0', '0xA2719263', '', '', '', '', 0, 0, 0, '0663882529', 'lee', '1980-01-01', 'f', 75, 2, 'Required');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;

-- Dumping structure for table gta5_gamemode_essential.user_appartement
CREATE TABLE IF NOT EXISTS `user_appartement` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(60) NOT NULL,
  `name` varchar(255) NOT NULL,
  `price` int(11) NOT NULL,
  `money` int(11) NOT NULL DEFAULT '0',
  `dirtymoney` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=22 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

-- Dumping data for table gta5_gamemode_essential.user_appartement: 0 rows
/*!40000 ALTER TABLE `user_appartement` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_appartement` ENABLE KEYS */;

-- Dumping structure for table gta5_gamemode_essential.user_boat
CREATE TABLE IF NOT EXISTS `user_boat` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(255) NOT NULL,
  `boat_name` varchar(255) DEFAULT NULL,
  `boat_model` varchar(255) DEFAULT NULL,
  `boat_price` int(60) DEFAULT NULL,
  `boat_plate` varchar(255) DEFAULT NULL,
  `boat_state` varchar(255) DEFAULT NULL,
  `boat_colorprimary` varchar(255) DEFAULT NULL,
  `boat_colorsecondary` varchar(255) DEFAULT NULL,
  `boat_pearlescentcolor` varchar(255) DEFAULT NULL,
  `boat_wheelcolor` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `boat_plate` (`boat_plate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table gta5_gamemode_essential.user_boat: ~0 rows (approximately)
/*!40000 ALTER TABLE `user_boat` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_boat` ENABLE KEYS */;

-- Dumping structure for table gta5_gamemode_essential.user_clothes
CREATE TABLE IF NOT EXISTS `user_clothes` (
  `identifier` varchar(255) NOT NULL,
  `skin` varchar(255) NOT NULL DEFAULT 'mp_m_freemode_01',
  `face` varchar(255) NOT NULL DEFAULT '0',
  `face_texture` varchar(255) NOT NULL DEFAULT '0',
  `hair` varchar(255) NOT NULL DEFAULT '11',
  `hair_texture` varchar(255) NOT NULL DEFAULT '4',
  `shirt` varchar(255) NOT NULL DEFAULT '0',
  `shirt_texture` varchar(255) NOT NULL DEFAULT '0',
  `pants` varchar(255) NOT NULL DEFAULT '8',
  `pants_texture` varchar(255) NOT NULL DEFAULT '0',
  `shoes` varchar(255) NOT NULL DEFAULT '1',
  `shoes_texture` varchar(255) NOT NULL DEFAULT '0',
  `vest` varchar(255) NOT NULL DEFAULT '0',
  `vest_texture` varchar(255) NOT NULL DEFAULT '0',
  `bag` varchar(255) NOT NULL DEFAULT '40',
  `bag_texture` varchar(255) NOT NULL DEFAULT '0',
  `hat` varchar(255) NOT NULL DEFAULT '1',
  `hat_texture` varchar(255) NOT NULL DEFAULT '1',
  `mask` varchar(255) NOT NULL DEFAULT '0',
  `mask_texture` varchar(255) NOT NULL DEFAULT '0',
  `glasses` varchar(255) NOT NULL DEFAULT '6',
  `glasses_texture` varchar(255) NOT NULL DEFAULT '0',
  `gloves` varchar(255) NOT NULL DEFAULT '2',
  `gloves_texture` varchar(255) NOT NULL DEFAULT '0',
  `jacket` varchar(255) NOT NULL DEFAULT '7',
  `jacket_texture` varchar(255) NOT NULL DEFAULT '2',
  `ears` varchar(255) NOT NULL DEFAULT '1',
  `ears_texture` varchar(255) NOT NULL DEFAULT '0',
  PRIMARY KEY (`identifier`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- Dumping data for table gta5_gamemode_essential.user_clothes: ~1 rows (approximately)
/*!40000 ALTER TABLE `user_clothes` DISABLE KEYS */;
INSERT INTO `user_clothes` (`identifier`, `skin`, `face`, `face_texture`, `hair`, `hair_texture`, `shirt`, `shirt_texture`, `pants`, `pants_texture`, `shoes`, `shoes_texture`, `vest`, `vest_texture`, `bag`, `bag_texture`, `hat`, `hat_texture`, `mask`, `mask_texture`, `glasses`, `glasses_texture`, `gloves`, `gloves_texture`, `jacket`, `jacket_texture`, `ears`, `ears_texture`) VALUES
	('steam:110000107aff8a1', 'mp_m_freemode_01', '0', '0', '11', '4', '0', '0', '8', '0', '1', '0', '0', '0', '40', '0', '1', '1', '0', '0', '6', '0', '2', '0', '7', '2', '1', '0');
/*!40000 ALTER TABLE `user_clothes` ENABLE KEYS */;

-- Dumping structure for table gta5_gamemode_essential.user_garage
CREATE TABLE IF NOT EXISTS `user_garage` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(255) NOT NULL,
  `garage_id` int(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- Dumping data for table gta5_gamemode_essential.user_garage: ~1 rows (approximately)
/*!40000 ALTER TABLE `user_garage` DISABLE KEYS */;
INSERT INTO `user_garage` (`id`, `identifier`, `garage_id`) VALUES
	(2, 'steam:110000107aff8a1', 6);
/*!40000 ALTER TABLE `user_garage` ENABLE KEYS */;

-- Dumping structure for table gta5_gamemode_essential.user_heli
CREATE TABLE IF NOT EXISTS `user_heli` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(255) NOT NULL,
  `heli_name` varchar(255) DEFAULT NULL,
  `heli_model` varchar(255) DEFAULT NULL,
  `heli_price` int(60) DEFAULT NULL,
  `heli_plate` varchar(255) DEFAULT NULL,
  `heli_state` varchar(255) DEFAULT NULL,
  `heli_colorprimary` varchar(255) DEFAULT NULL,
  `heli_colorsecondary` varchar(255) DEFAULT NULL,
  `heli_pearlescentcolor` varchar(255) DEFAULT NULL,
  `heli_wheelcolor` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `heli_plate` (`heli_plate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table gta5_gamemode_essential.user_heli: ~0 rows (approximately)
/*!40000 ALTER TABLE `user_heli` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_heli` ENABLE KEYS */;

-- Dumping structure for table gta5_gamemode_essential.user_inventory
CREATE TABLE IF NOT EXISTS `user_inventory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(60) NOT NULL,
  `item_id` int(11) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1565 DEFAULT CHARSET=utf8;

-- Dumping data for table gta5_gamemode_essential.user_inventory: ~1 rows (approximately)
/*!40000 ALTER TABLE `user_inventory` DISABLE KEYS */;
INSERT INTO `user_inventory` (`id`, `identifier`, `item_id`, `quantity`) VALUES
	(1564, 'steam:110000107aff8a1', 8, 1);
/*!40000 ALTER TABLE `user_inventory` ENABLE KEYS */;

-- Dumping structure for table gta5_gamemode_essential.user_job_inventory
CREATE TABLE IF NOT EXISTS `user_job_inventory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(60) DEFAULT NULL,
  `item_id` int(60) DEFAULT NULL,
  `quantity` int(60) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=329 DEFAULT CHARSET=utf8;

-- Dumping data for table gta5_gamemode_essential.user_job_inventory: ~0 rows (approximately)
/*!40000 ALTER TABLE `user_job_inventory` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_job_inventory` ENABLE KEYS */;

-- Dumping structure for table gta5_gamemode_essential.user_licence
CREATE TABLE IF NOT EXISTS `user_licence` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(255) NOT NULL,
  `licence_id` int(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=265 DEFAULT CHARSET=utf8;

-- Dumping data for table gta5_gamemode_essential.user_licence: ~0 rows (approximately)
/*!40000 ALTER TABLE `user_licence` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_licence` ENABLE KEYS */;

-- Dumping structure for table gta5_gamemode_essential.user_plane
CREATE TABLE IF NOT EXISTS `user_plane` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(255) NOT NULL,
  `plane_name` varchar(255) DEFAULT NULL,
  `plane_model` varchar(255) DEFAULT NULL,
  `plane_price` int(60) DEFAULT NULL,
  `plane_plate` varchar(255) DEFAULT NULL,
  `plane_state` varchar(255) DEFAULT NULL,
  `plane_colorprimary` varchar(255) DEFAULT NULL,
  `plane_colorsecondary` varchar(255) DEFAULT NULL,
  `plane_pearlescentcolor` varchar(255) DEFAULT NULL,
  `plane_wheelcolor` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `plane_plate` (`plane_plate`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- Dumping data for table gta5_gamemode_essential.user_plane: ~0 rows (approximately)
/*!40000 ALTER TABLE `user_plane` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_plane` ENABLE KEYS */;

-- Dumping structure for table gta5_gamemode_essential.user_vehicle
CREATE TABLE IF NOT EXISTS `user_vehicle` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(255) NOT NULL,
  `garage_id` int(255) DEFAULT '22',
  `vehicle_name` varchar(60) DEFAULT NULL,
  `vehicle_model` varchar(60) DEFAULT NULL,
  `vehicle_price` int(60) DEFAULT NULL,
  `vehicle_plate` varchar(60) DEFAULT NULL,
  `vehicle_state` varchar(60) DEFAULT NULL,
  `vehicle_colorprimary` varchar(60) DEFAULT NULL,
  `vehicle_colorsecondary` varchar(60) DEFAULT NULL,
  `vehicle_pearlescentcolor` varchar(60) DEFAULT NULL,
  `vehicle_wheelcolor` varchar(60) DEFAULT NULL,
  `vehicle_plateindex` varchar(255) DEFAULT NULL,
  `vehicle_neoncolor1` varchar(255) DEFAULT NULL,
  `vehicle_neoncolor2` varchar(255) DEFAULT NULL,
  `vehicle_neoncolor3` varchar(25) DEFAULT NULL,
  `vehicle_windowtint` varchar(255) DEFAULT NULL,
  `vehicle_wheeltype` varchar(255) DEFAULT NULL,
  `vehicle_mods0` varchar(255) DEFAULT NULL,
  `vehicle_mods1` varchar(255) DEFAULT NULL,
  `vehicle_mods2` varchar(255) DEFAULT NULL,
  `vehicle_mods3` varchar(255) DEFAULT NULL,
  `vehicle_mods4` varchar(255) DEFAULT NULL,
  `vehicle_mods5` varchar(255) DEFAULT NULL,
  `vehicle_mods6` varchar(255) DEFAULT NULL,
  `vehicle_mods7` varchar(255) DEFAULT NULL,
  `vehicle_mods8` varchar(255) DEFAULT NULL,
  `vehicle_mods9` varchar(255) DEFAULT NULL,
  `vehicle_mods10` varchar(255) DEFAULT NULL,
  `vehicle_mods11` varchar(255) DEFAULT NULL,
  `vehicle_mods12` varchar(255) DEFAULT NULL,
  `vehicle_mods13` varchar(255) DEFAULT NULL,
  `vehicle_mods14` varchar(255) DEFAULT NULL,
  `vehicle_mods15` varchar(255) DEFAULT NULL,
  `vehicle_mods16` varchar(255) DEFAULT NULL,
  `vehicle_turbo` varchar(255) NOT NULL DEFAULT 'off',
  `vehicle_tiresmoke` varchar(255) NOT NULL DEFAULT 'off',
  `vehicle_xenon` varchar(255) NOT NULL DEFAULT 'off',
  `vehicle_mods23` varchar(255) DEFAULT NULL,
  `vehicle_mods24` varchar(255) DEFAULT NULL,
  `vehicle_neon0` varchar(255) DEFAULT NULL,
  `vehicle_neon1` varchar(255) DEFAULT NULL,
  `vehicle_neon2` varchar(255) DEFAULT NULL,
  `vehicle_neon3` varchar(255) DEFAULT NULL,
  `vehicle_bulletproof` varchar(255) DEFAULT NULL,
  `vehicle_smokecolor1` varchar(255) DEFAULT NULL,
  `vehicle_smokecolor2` varchar(255) DEFAULT NULL,
  `vehicle_smokecolor3` varchar(255) DEFAULT NULL,
  `vehicle_modvariation` varchar(255) NOT NULL DEFAULT 'off',
  `insurance` varchar(255) NOT NULL DEFAULT 'off',
  `instance` int(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `vehicle_plate` (`vehicle_plate`)
) ENGINE=InnoDB AUTO_INCREMENT=422 DEFAULT CHARSET=utf8;

-- Dumping data for table gta5_gamemode_essential.user_vehicle: ~0 rows (approximately)
/*!40000 ALTER TABLE `user_vehicle` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_vehicle` ENABLE KEYS */;

-- Dumping structure for table gta5_gamemode_essential.user_weapons
CREATE TABLE IF NOT EXISTS `user_weapons` (
  `ID` int(10) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(255) NOT NULL,
  `weapon_model` varchar(60) NOT NULL,
  `withdraw_cost` int(10) NOT NULL,
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3873 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- Dumping data for table gta5_gamemode_essential.user_weapons: ~0 rows (approximately)
/*!40000 ALTER TABLE `user_weapons` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_weapons` ENABLE KEYS */;

-- Dumping structure for table gta5_gamemode_essential.user_whitelist
CREATE TABLE IF NOT EXISTS `user_whitelist` (
  `identifier` varchar(255) NOT NULL,
  `whitelisted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table gta5_gamemode_essential.user_whitelist: ~0 rows (approximately)
/*!40000 ALTER TABLE `user_whitelist` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_whitelist` ENABLE KEYS */;

-- Dumping structure for table gta5_gamemode_essential.vehicles
CREATE TABLE IF NOT EXISTS `vehicles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `price` int(255) NOT NULL,
  `model` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=165 DEFAULT CHARSET=utf8;

-- Dumping data for table gta5_gamemode_essential.vehicles: ~164 rows (approximately)
/*!40000 ALTER TABLE `vehicles` DISABLE KEYS */;
INSERT INTO `vehicles` (`id`, `name`, `price`, `model`) VALUES
	(1, 'Blista', 22000, 'blista'),
	(2, 'Brioso R/A', 20000, 'brioso'),
	(3, 'Dilettante', 20000, 'Dilettante'),
	(4, 'Issi', 30000, 'issi2'),
	(5, 'Panto', 15000, 'panto'),
	(6, 'Prairie', 37000, 'prairie'),
	(7, 'Rhapsody', 24000, 'rhapsody'),
	(8, 'Cognoscenti Cabrio', 50000, 'cogcabrio'),
	(9, 'Exemplar', 60000, 'exemplar'),
	(10, 'F620', 80000, 'f620'),
	(11, 'Felon', 90000, 'felon'),
	(12, 'Felon GT', 95000, 'felon2'),
	(13, 'Jackal', 60000, 'jackal'),
	(14, 'Oracle', 80000, 'oracle'),
	(15, 'Oracle XS', 89000, 'oracle2'),
	(16, 'Sentinel', 65000, 'sentinel'),
	(17, 'Sentinel XS', 70000, 'sentinel2'),
	(18, 'Windsor', 120000, 'windsor'),
	(19, 'Windsor Drop', 150000, 'windsor2'),
	(20, 'Zion', 85000, 'zion'),
	(21, 'Zion Cabrio', 95000, 'zion2'),
	(22, '9F', 200000, 'ninef'),
	(23, '9F Cabrio', 230000, 'ninef2'),
	(24, 'Alpha', 130000, 'alpha'),
	(25, 'Banshee', 100000, 'banshee'),
	(26, 'Bestia GTS', 250000, 'bestiagts'),
	(27, 'Blista Compact', 22000, 'blista'),
	(28, 'Buffalo', 45000, 'buffalo'),
	(29, 'Buffalo S', 55000, 'buffalo2'),
	(30, 'Carbonizzare', 195000, 'carbonizzare'),
	(31, 'Comet', 175000, 'comet2'),
	(32, 'Coquette', 270000, 'coquette'),
	(33, 'Drift Tampa', 595000, 'tampa2'),
	(34, 'Feltzer', 150000, 'feltzer2'),
	(35, 'Furore GT', 248000, 'furoregt'),
	(36, 'Fusilade', 45000, 'fusilade'),
	(37, 'Jester', 240000, 'jester'),
	(38, 'Jester(Racecar)', 249000, 'jester2'),
	(39, 'Kuruma', 95000, 'kuruma'),
	(40, 'Lynx', 445000, 'lynx'),
	(41, 'Massacro', 225000, 'massacro'),
	(42, 'Massacro(Racecar)', 315000, 'massacro2'),
	(43, 'Omnis', 101000, 'omnis'),
	(44, 'Penumbra', 44000, 'penumbra'),
	(45, 'Rapid GT', 140000, 'rapidgt'),
	(46, 'Rapid GT Convertible', 150000, 'rapidgt2'),
	(47, 'Schafter V12', 200000, 'schafter3'),
	(48, 'Sultan', 35000, 'sultan'),
	(49, 'Surano', 110000, 'surano'),
	(50, 'Tropos', 716000, 'tropos'),
	(51, 'Verkierer', 305000, 'verlierer2'),
	(52, 'Casco', 580000, 'casco'),
	(53, 'Coquette Classic', 565000, 'coquette2'),
	(54, 'JB 700', 350000, 'jb700'),
	(55, 'Pigalle', 400000, 'pigalle'),
	(56, 'Stinger', 550000, 'stinger'),
	(57, 'Stinger GT', 775000, 'stingergt'),
	(58, 'Stirling GT', 875000, 'feltzer3'),
	(59, 'Z-Type', 850000, 'ztype'),
	(60, 'Adder', 1200000, 'adder'),
	(61, 'Banshee 900R', 409000, 'banshee2'),
	(62, 'Bullet', 211000, 'bullet'),
	(63, 'Cheetah', 550000, 'cheetah'),
	(64, 'Entity XF', 695000, 'entityxf'),
	(65, 'ETR1', 250500, 'sheava'),
	(66, 'FMJ', 950000, 'fmj'),
	(67, 'Infernus', 540000, 'infernus'),
	(68, 'Osiris', 1100000, 'osiris'),
	(69, 'RE-7B', 1175000, 'le7b'),
	(70, 'Reaper', 855000, 'reaper'),
	(71, 'Sultan RS', 300000, 'sultanrs'),
	(72, 'T20', 1150000, 't20'),
	(73, 'Turismo R', 750000, 'turismor'),
	(74, 'Tyrus', 1550000, 'tyrus'),
	(75, 'Vacca', 440000, 'vacca'),
	(76, 'Voltic', 150000, 'voltic'),
	(77, 'X80 Proto', 1500000, 'prototipo'),
	(78, 'Zentorno', 855000, 'zentorno'),
	(79, 'Blade', 45000, 'blade'),
	(80, 'Buccaneer', 49000, 'buccaneer'),
	(81, 'Chino', 50000, 'chino'),
	(82, 'Coquette BlackFin', 199000, 'coquette3'),
	(83, 'Dominator', 66600, 'dominator'),
	(84, 'Dukes', 62000, 'dukes'),
	(85, 'Gauntlet', 70000, 'gauntlet'),
	(86, 'Hotknife', 90000, 'hotknife'),
	(87, 'Faction', 36000, 'faction'),
	(88, 'Nightshade', 185000, 'nightshade'),
	(89, 'Picador', 17000, 'picador'),
	(90, 'Sabre Turbo', 55000, 'sabregt'),
	(91, 'Tampa', 75000, 'tampa'),
	(92, 'Virgo', 95000, 'virgo'),
	(93, 'Vigero', 70000, 'vigero'),
	(94, 'Bifta', 30000, 'bifta'),
	(95, 'Blazer', 8000, 'blazer'),
	(96, 'Brawler', 125000, 'brawler'),
	(97, 'Bubsta 6x6', 210000, 'dubsta3'),
	(98, 'Dune Buggy', 20000, 'dune'),
	(99, 'Rebel', 22000, 'rebel2'),
	(100, 'Sandking', 85000, 'sandking'),
	(101, 'The Liberator', 550000, 'monster'),
	(102, 'Trophy Truck', 250000, 'trophytruck'),
	(103, 'Baller', 90000, 'baller'),
	(104, 'Cavalcade', 60000, 'cavalcade'),
	(105, 'Grabger', 35000, 'granger'),
	(106, 'Huntley S', 105000, 'huntley'),
	(107, 'Landstalker', 58000, 'landstalker'),
	(108, 'Radius', 32000, 'radi'),
	(109, 'Rocoto', 85000, 'rocoto'),
	(110, 'Seminole', 30000, 'seminole'),
	(111, 'XLS', 103000, 'xls'),
	(112, 'Bison', 35000, 'bison'),
	(113, 'Bobcat XL', 30000, 'bobcatxl'),
	(114, 'Gang Burrito', 65000, 'gburrito'),
	(115, 'Journey', 15000, 'journey'),
	(116, 'Minivan', 30000, 'minivan'),
	(117, 'Paradise', 25000, 'paradise'),
	(118, 'Rumpo', 20000, 'rumpo'),
	(119, 'Surfer', 15000, 'surfer'),
	(120, 'Youga', 22000, 'youga'),
	(121, 'Asea', 50000, 'asea'),
	(122, 'Asterope', 50000, 'asterope'),
	(123, 'Fugitive', 45000, 'fugitive'),
	(124, 'Glendale', 20000, 'glendale'),
	(125, 'Ingot', 9000, 'ingot'),
	(126, 'Intruder', 16000, 'intruder'),
	(127, 'Premier', 17000, 'premier'),
	(128, 'Primo', 11000, 'primo'),
	(129, 'Primo Custom', 12500, 'primo2'),
	(130, 'Regina', 8000, 'regina'),
	(131, 'Schafter', 65000, 'schafter2'),
	(132, 'Stanier', 19000, 'stanier'),
	(133, 'Stratum', 10000, 'stratum'),
	(134, 'Stretch', 95000, 'stretch'),
	(135, 'Super Diamond', 150000, 'superd'),
	(136, 'Surge', 38000, 'surge'),
	(137, 'Tailgater', 95000, 'tailgater'),
	(138, 'Warrener', 30000, 'warrener'),
	(139, 'Washington', 32000, 'washington'),
	(140, 'Akuma', 9000, 'AKUMA'),
	(141, 'Bagger', 5000, 'bagger'),
	(142, 'Bati 801', 15000, 'bati'),
	(143, 'Bati 801RR', 15000, 'bati2'),
	(144, 'BF400', 45000, 'bf400'),
	(145, 'Carbon RS', 40000, 'carbonrs'),
	(146, 'Cliffhanger', 55000, 'cliffhanger'),
	(147, 'Daemon', 15000, 'daemon'),
	(148, 'Double T', 12000, 'double'),
	(149, 'Enduro', 28000, 'enduro'),
	(150, 'Faggio', 4000, 'faggio2'),
	(151, 'Gargoyle', 60000, 'gargoyle'),
	(152, 'Hakuchou', 82000, 'hakuchou'),
	(153, 'Hexer', 15000, 'hexer'),
	(154, 'Innovation', 90000, 'innovation'),
	(155, 'Lectro', 700000, 'lectro'),
	(156, 'Nemesis', 12000, 'nemesis'),
	(157, 'PCJ-600', 9000, 'pcj'),
	(158, 'Ruffian', 9000, 'ruffian'),
	(159, 'Sanchez', 7000, 'sanchez'),
	(160, 'Sovereign', 65000, 'sovereign'),
	(161, 'Thrust', 45000, 'thrust'),
	(162, 'Vader', 9000, 'vader'),
	(163, 'Vindicator', 95000, 'vindicator'),
	(164, 'Baller Armored 6', 100000000, 'baller6');
/*!40000 ALTER TABLE `vehicles` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
