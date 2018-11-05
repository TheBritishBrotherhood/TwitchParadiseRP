CREATE TABLE IF NOT EXISTS `user_plane` (
  `id` int(11) AUTO_INCREMENT,
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE `user_plane` ADD UNIQUE KEY `plane_plate` (`plane_plate`);