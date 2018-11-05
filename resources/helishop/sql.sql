CREATE TABLE IF NOT EXISTS `user_heli` (
  `id` int(11) AUTO_INCREMENT,
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
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE `user_heli` ADD UNIQUE KEY `heli_plate` (`heli_plate`);
