CREATE TABLE IF NOT EXISTS `user_weapons` (
  `id` int AUTO_INCREMENT,
  `identifier` varchar(255) NOT NULL,
  `weapon_model` varchar(255) NOT NULL,
  `withdraw_cost` int NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT fk_user_weapon FOREIGN KEY(identifier) REFERENCES users(identifier) ON DELETE CASCADE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ;
