/*
 * Copyright (C) 2016+ AzerothCore <www.azerothcore.org>, released under GNU AGPL v3 license: https://github.com/azerothcore/azerothcore-wotlk/blob/master/LICENSE-AGPL3
 */

#ifndef DEF_QUEST_HELPER_MGR_H
#define DEF_QUEST_HELPER_MGR_H

#include "Define.h"
#include <string>
#include <unordered_map>
#include <vector>

static constexpr char QUEST_HELPER_MODULE[] = "mod-quest-helper";

enum QuestHelperStrings : uint32
{
    LANG_QUEST_HELPER_AUTO_COMPLETE             = 1,
    LANG_QUEST_HELPER_AUTO_COMPLETE_REWARD      = 2,
    LANG_QUEST_HELPER_WELCOME                   = 3,
    LANG_QUEST_HELPER_MESSAGES_ON               = 4,
    LANG_QUEST_HELPER_MESSAGES_OFF              = 5,
    LANG_QUEST_HELPER_CMD_QUEST_NOT_FOUND       = 6,
    LANG_QUEST_HELPER_CMD_INVALID_FLAG          = 7,
    LANG_QUEST_HELPER_CMD_QUEST_ADDED           = 8,
    LANG_QUEST_HELPER_CMD_QUEST_NOT_REGISTERED  = 9,
    LANG_QUEST_HELPER_CMD_QUEST_REMOVED         = 10,
    LANG_QUEST_HELPER_COMMENT                   = 11,
    LANG_QUEST_HELPER_CMD_COMMENT_ADDED         = 12,
    LANG_QUEST_HELPER_CMD_COMMENT_NOT_FOUND     = 13,
    LANG_QUEST_HELPER_CMD_COMMENT_REMOVED       = 14,
    LANG_QUEST_HELPER_CMD_COMMENT_HIDDEN        = 15,
    LANG_QUEST_HELPER_CMD_RELOADED              = 16,
    // .qh info output
    LANG_QUEST_HELPER_INFO_NOT_FLAGGED          = 17,
    LANG_QUEST_HELPER_INFO_AUTO_COMPLETE        = 18,
    LANG_QUEST_HELPER_INFO_AUTO_COMPLETE_REWARD = 19,
    LANG_QUEST_HELPER_INFO_TEMP                 = 20,
    LANG_QUEST_HELPER_INFO_REASON               = 21,
    // .qh addtemp GM confirmation
    LANG_QUEST_HELPER_CMD_QUEST_ADDED_TEMP      = 22,
};

enum QuestHelperSettingIndex : uint8
{
    SETTING_QH_FLAGS = 0,
};

enum QuestHelperFlags : uint32
{
    QH_FLAG_HIDE_MESSAGES = 1,
};

enum QuestAutoCompleteFlag : uint8
{
    QUEST_AUTO_FLAG_NONE             = 0,
    QUEST_AUTO_FLAG_COMPLETE         = 0x01, // Mark quest as complete only
    QUEST_AUTO_FLAG_COMPLETE_REWARD  = 0x02, // Mark quest as complete and grant reward
    QUEST_AUTO_FLAG_UNTIL_RESTART    = 0x04, // Modifier: entry is purged from DB on next startup
    QUEST_AUTO_FLAG_BEHAVIOR_MASK    = 0x03, // Masks out modifier bits to get the base behavior
};

struct QuestComment
{
    uint32      id;
    std::string text;
    bool        enabled;
};

// Stores the raw flag (including any modifier bits) and optional reason for a flagged quest.
struct QuestEntry
{
    uint8       flag;   // raw stored value; mask with QUEST_AUTO_FLAG_BEHAVIOR_MASK for behavior
    std::string reason;
};

class QuestHelperMgr
{
public:
    static QuestHelperMgr* instance();

    void LoadConfig();
    void LoadAutoCompleteQuests();
    // Deletes all until_restart entries from the DB. Called once at startup before loading.
    void PurgeUntilRestartFlags();
    void AddAutoCompleteQuest(uint32 questId, uint8 flag, uint32 realmId, std::string const& reason = {});
    bool RemoveAutoCompleteQuest(uint32 questId, uint32 realmId);

    void   LoadQuestComments();
    uint32 AddQuestComment(uint32 questId, uint32 realmId, std::string const& comment);
    bool   RemoveQuestComment(uint32 commentId);
    bool   HideQuestComment(uint32 commentId);
    std::vector<std::string> GetEnabledComments(uint32 questId, uint32 realmId) const;

    bool IsEnabled() const { return _enabled; }
    bool IsWelcomeMessageEnabled() const { return _welcomeMessageEnabled; }

    // Returns nullptr if the quest/realm pair has no entry.
    QuestEntry const* GetQuestEntry(uint32 questId, uint32 realmId) const;

    // Returns the behavior flag (COMPLETE or COMPLETE_REWARD), stripping modifier bits.
    uint8 GetFlag(uint32 questId, uint32 realmId) const;

    bool IsAutoComplete(uint32 questId, uint32 realmId) const;
    bool IsAutoRewarded(uint32 questId, uint32 realmId) const;

private:
    static uint64 MakeKey(uint32 questId, uint32 realmId)
    {
        return (static_cast<uint64>(realmId) << 32) | static_cast<uint64>(questId);
    }

    bool _enabled = false;
    bool _welcomeMessageEnabled = false;
    std::unordered_map<uint64, QuestEntry>                 _autoCompleteQuests;
    std::unordered_map<uint64, std::vector<QuestComment>>  _questComments;
    std::unordered_map<uint32, uint64>                     _commentIdIndex;
};

#define sQuestHelperMgr QuestHelperMgr::instance()

#endif // DEF_QUEST_HELPER_MGR_H
