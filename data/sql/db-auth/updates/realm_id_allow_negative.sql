--
-- Allow realmId = -1 as an "all realms" sentinel in quest helper tables.
--
ALTER TABLE `quest_completer_quests`
    MODIFY COLUMN `realmId` int NOT NULL COMMENT 'Realm ID from realmlist.id; -1 = all realms';

ALTER TABLE `quest_helper_comments`
    MODIFY COLUMN `realmId` int NOT NULL COMMENT 'Realm ID from realmlist.id; -1 = all realms';
