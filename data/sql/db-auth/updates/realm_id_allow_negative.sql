--
-- Change realmId to signed INT so -1 can be stored as "current realm" sentinel,
-- matching the convention used by AzerothCore's RBAC system.
--
ALTER TABLE `quest_completer_quests`
    MODIFY COLUMN `realmId` int NOT NULL COMMENT 'Realm ID from realmlist.id; -1 = current realm (all realms)';

ALTER TABLE `quest_helper_comments`
    MODIFY COLUMN `realmId` int NOT NULL COMMENT 'Realm ID from realmlist.id; -1 = current realm (all realms)';
