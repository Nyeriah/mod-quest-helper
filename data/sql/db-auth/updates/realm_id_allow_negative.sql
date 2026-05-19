--
-- Store REALM_ID_ALL (0xFFFFFFFF = 4294967295) as the "all realms" sentinel.
-- INT UNSIGNED fits 0..4294967295, so no sign change is needed.
-- This reverts any prior signed INT migration back to INT UNSIGNED.
--
ALTER TABLE `quest_completer_quests`
    MODIFY COLUMN `realmId` int unsigned NOT NULL COMMENT 'Realm ID from realmlist.id; 4294967295 = all realms';

ALTER TABLE `quest_helper_comments`
    MODIFY COLUMN `realmId` int unsigned NOT NULL COMMENT 'Realm ID from realmlist.id; 4294967295 = all realms';
