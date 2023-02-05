CREATE TABLE IF NOT EXISTS `verification` (
  `user_id` int NOT NULL,
  `code` varchar(100) DEFAULT NULL,
  `discord_id` varchar(300) DEFAULT NULL,
  `verified` boolean DEFAULT FALSE,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;