--
-- Table structure for `quest_helper_comments`
-- Stores GM comments shown to players when they accept a quest.
-- A quest may have multiple comments per realm.
-- enabled: 1=active (shown to players), 0=hidden (suppressed without deletion)
--

CREATE TABLE IF NOT EXISTS `quest_helper_comments` (
  `id`      int unsigned NOT NULL AUTO_INCREMENT COMMENT 'Unique comment ID',
  `questId` int unsigned NOT NULL COMMENT 'Quest template ID',
  `realmId` int unsigned NOT NULL COMMENT 'Realm ID from realmlist.id; 4294967295 = all realms',
  `comment` varchar(500) NOT NULL COMMENT 'Message displayed to the player on quest accept',
  `enabled` tinyint unsigned NOT NULL DEFAULT '1' COMMENT '1=active, 0=hidden',
  PRIMARY KEY (`id`),
  KEY `idx_quest_realm` (`questId`, `realmId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
