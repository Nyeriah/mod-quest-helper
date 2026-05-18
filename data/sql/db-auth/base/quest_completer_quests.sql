--
-- Table structure for `quest_completer_quests`
-- Stores per-realm quest forcing rules loaded into memory at startup.
-- flag: 1 = mark complete only, 2 = mark complete and reward
--

CREATE TABLE IF NOT EXISTS `quest_completer_quests` (
  `questId` int unsigned NOT NULL COMMENT 'Quest template ID',
  `flag`    tinyint unsigned NOT NULL DEFAULT '1' COMMENT '0x01=complete, 0x02=complete+reward, 0x04=until_restart',
  `realmId` int NOT NULL COMMENT 'Realm ID from realmlist.id; -1 = all realms',
  `reason`  varchar(255) DEFAULT NULL COMMENT 'Optional note explaining why this quest is auto-completed',
  PRIMARY KEY (`questId`, `realmId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
