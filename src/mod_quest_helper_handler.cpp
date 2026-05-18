/*
 * Copyright (C) 2016+ AzerothCore <www.azerothcore.org>, released under GNU AGPL v3 license: https://github.com/azerothcore/azerothcore-wotlk/blob/master/LICENSE-AGPL3
 */

#include "QuestHelperMgr.h"
#include "Config.h"
#include "DatabaseEnv.h"
#include "Log.h"
#include "QueryResult.h"
#include <algorithm>

QuestHelperMgr* QuestHelperMgr::instance()
{
    static QuestHelperMgr instance;
    return &instance;
}

void QuestHelperMgr::LoadConfig()
{
    _enabled               = sConfigMgr->GetOption<bool>("QuestHelper.Enable", false);
    _welcomeMessageEnabled = sConfigMgr->GetOption<bool>("QuestHelper.WelcomeMessage.Enable", true);
}

void QuestHelperMgr::PurgeUntilRestartFlags()
{
    if (!_enabled)
        return;

    LoginDatabase.DirectExecute(
        "DELETE FROM `quest_completer_quests` WHERE (`flag` & {}) != 0", uint32(QUEST_AUTO_FLAG_UNTIL_RESTART));
    LOG_INFO("module", "Quest Helper: purged until-restart flags.");
}

void QuestHelperMgr::LoadAutoCompleteQuests()
{
    _autoCompleteQuests.clear();

    if (!_enabled)
        return;

    LOG_INFO("module", "Loading Quest Helper auto-complete quest data...");

    QueryResult result = LoginDatabase.Query(
        "SELECT `questId`, `flag`, `realmId`, `reason` FROM `quest_completer_quests`");
    if (!result)
    {
        LOG_INFO("module", ">> Loaded 0 auto-complete quests.");
        return;
    }

    uint32 count = 0;
    do
    {
        Field* fields = result->Fetch();

        uint32 questId     = fields[0].Get<uint32>();
        uint8  flag        = fields[1].Get<uint8>();
        uint32 realmId     = static_cast<uint32>(fields[2].Get<int32>());
        std::string reason = fields[3].Get<std::string>();

        _autoCompleteQuests[MakeKey(questId, realmId)] = { flag, std::move(reason) };
        ++count;
    } while (result->NextRow());

    LOG_INFO("module", ">> Loaded {} auto-complete quest(s).", count);
}

void QuestHelperMgr::AddAutoCompleteQuest(uint32 questId, uint8 flag, uint32 realmId, std::string const& reason)
{
    _autoCompleteQuests[MakeKey(questId, realmId)] = { flag, reason };

    std::string escapedReason = reason;
    LoginDatabase.EscapeString(escapedReason);
    LoginDatabase.Execute(
        "REPLACE INTO `quest_completer_quests` (`questId`, `flag`, `realmId`, `reason`) VALUES ({}, {}, {}, '{}')",
        questId, uint32(flag), realmId, escapedReason);
}

bool QuestHelperMgr::RemoveAutoCompleteQuest(uint32 questId, uint32 realmId)
{
    auto itr = _autoCompleteQuests.find(MakeKey(questId, realmId));
    if (itr == _autoCompleteQuests.end())
        return false;

    _autoCompleteQuests.erase(itr);
    LoginDatabase.Execute(
        "DELETE FROM `quest_completer_quests` WHERE `questId` = {} AND `realmId` = {}",
        questId, realmId);
    return true;
}

void QuestHelperMgr::LoadQuestComments()
{
    _questComments.clear();
    _commentIdIndex.clear();

    if (!_enabled)
        return;

    LOG_INFO("module", "Loading Quest Helper quest comments...");

    QueryResult result = LoginDatabase.Query(
        "SELECT `id`, `questId`, `realmId`, `comment`, `enabled` FROM `quest_helper_comments`");
    if (!result)
    {
        LOG_INFO("module", ">> Loaded 0 quest comments.");
        return;
    }

    uint32 count = 0;
    do
    {
        Field* fields = result->Fetch();

        uint32 id        = fields[0].Get<uint32>();
        uint32 questId   = fields[1].Get<uint32>();
        uint32 realmId   = static_cast<uint32>(fields[2].Get<int32>());
        std::string text = fields[3].Get<std::string>();
        bool enabled     = fields[4].Get<bool>();

        uint64 key = MakeKey(questId, realmId);
        _questComments[key].push_back({ id, std::move(text), enabled });
        _commentIdIndex[id] = key;
        ++count;
    } while (result->NextRow());

    LOG_INFO("module", ">> Loaded {} quest comment(s).", count);
}

uint32 QuestHelperMgr::AddQuestComment(uint32 questId, uint32 realmId, std::string const& comment)
{
    std::string escapedComment = comment;
    LoginDatabase.EscapeString(escapedComment);
    LoginDatabase.DirectExecute(
        "INSERT INTO `quest_helper_comments` (`questId`, `realmId`, `comment`, `enabled`) VALUES ({}, {}, '{}', 1)",
        questId, realmId, escapedComment);

    QueryResult idResult = LoginDatabase.Query("SELECT LAST_INSERT_ID()");
    uint32 newId = idResult ? idResult->Fetch()[0].Get<uint32>() : 0;

    uint64 key = MakeKey(questId, realmId);
    _questComments[key].push_back({ newId, comment, true });
    _commentIdIndex[newId] = key;

    return newId;
}

bool QuestHelperMgr::RemoveQuestComment(uint32 commentId)
{
    auto indexItr = _commentIdIndex.find(commentId);
    if (indexItr == _commentIdIndex.end())
        return false;

    uint64 key = indexItr->second;
    _commentIdIndex.erase(indexItr);

    auto& vec = _questComments[key];
    vec.erase(std::remove_if(vec.begin(), vec.end(),
        [commentId](QuestComment const& c) { return c.id == commentId; }), vec.end());
    if (vec.empty())
        _questComments.erase(key);

    LoginDatabase.Execute("DELETE FROM `quest_helper_comments` WHERE `id` = {}", commentId);
    return true;
}

bool QuestHelperMgr::HideQuestComment(uint32 commentId)
{
    auto indexItr = _commentIdIndex.find(commentId);
    if (indexItr == _commentIdIndex.end())
        return false;

    auto& vec = _questComments[indexItr->second];
    for (QuestComment& c : vec)
    {
        if (c.id == commentId)
        {
            c.enabled = false;
            LoginDatabase.Execute(
                "UPDATE `quest_helper_comments` SET `enabled` = 0 WHERE `id` = {}", commentId);
            return true;
        }
    }
    return false;
}

std::vector<std::string> QuestHelperMgr::GetEnabledComments(uint32 questId, uint32 realmId) const
{
    std::vector<std::string> out;

    auto collect = [&](uint64 key)
    {
        auto itr = _questComments.find(key);
        if (itr == _questComments.end())
            return;
        for (QuestComment const& c : itr->second)
            if (c.enabled)
                out.push_back(c.text);
    };

    // Realm-specific comments first, then all-realms comments.
    collect(MakeKey(questId, realmId));
    if (realmId != REALM_ID_ALL)
        collect(MakeKey(questId, REALM_ID_ALL));

    return out;
}

QuestEntry const* QuestHelperMgr::GetQuestEntry(uint32 questId, uint32 realmId) const
{
    auto itr = _autoCompleteQuests.find(MakeKey(questId, realmId));
    if (itr != _autoCompleteQuests.end())
        return &itr->second;

    // Fall back to the all-realms entry if no realm-specific entry exists.
    if (realmId != REALM_ID_ALL)
    {
        itr = _autoCompleteQuests.find(MakeKey(questId, REALM_ID_ALL));
        if (itr != _autoCompleteQuests.end())
            return &itr->second;
    }

    return nullptr;
}

uint8 QuestHelperMgr::GetFlag(uint32 questId, uint32 realmId) const
{
    QuestEntry const* entry = GetQuestEntry(questId, realmId);
    return entry ? (entry->flag & QUEST_AUTO_FLAG_BEHAVIOR_MASK) : QUEST_AUTO_FLAG_NONE;
}

bool QuestHelperMgr::IsAutoComplete(uint32 questId, uint32 realmId) const
{
    uint8 flag = GetFlag(questId, realmId);
    return flag == QUEST_AUTO_FLAG_COMPLETE || flag == QUEST_AUTO_FLAG_COMPLETE_REWARD;
}

bool QuestHelperMgr::IsAutoRewarded(uint32 questId, uint32 realmId) const
{
    return GetFlag(questId, realmId) == QUEST_AUTO_FLAG_COMPLETE_REWARD;
}
