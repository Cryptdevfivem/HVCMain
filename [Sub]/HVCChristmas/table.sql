CREATE TABLE `user_rewards` (
  `license` varchar(50) NOT NULL,
  `days` int(11) DEFAULT NULL,
  `time` int(11) DEFAULT NULL,
  `rewardsReceived` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `weekday` text DEFAULT NULL
);

ALTER TABLE `user_rewards`
  ADD PRIMARY KEY (`license`);