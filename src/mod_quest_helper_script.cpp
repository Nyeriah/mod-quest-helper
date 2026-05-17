/*
 * Copyright (C) 2016+ AzerothCore <www.azerothcore.org>, released under GNU AGPL v3 license: https://github.com/azerothcore/azerothcore-wotlk/blob/master/LICENSE-AGPL3
 */

#include "Chat.h"
#include "Log.h"
#include "Player.h"
#include "PlayerSettings.h"
#include "Realm.h"
#include "ScriptMgr.h"
#include "World.h"
#include "QuestHelperMgr.h"

static void FulfillQuestObjectives(Player* player, Quest const* quest)
{
    // Set creature/GO kill counters to required values in the quest log
    uint16 slot = player->FindQuestSlot(quest->GetQuestId());
    if (slot < MAX_QUEST_LOG_SIZE)
    {
        for (uint8 i = 0; i < QUEST_OBJECTIVES_COUNT; ++i)
            if (quest->RequiredNpcOrGoCount[i])
                player->SetQuestSlotCounter(slot, i, quest->RequiredNpcOrGoCount[i]);
    }

    // Add any required collection items the player is missing
    for (uint8 i = 0; i < QUEST_ITEM_OBJECTIVES_COUNT; ++i)
    {
        uint32 itemId = quest->RequiredItemId[i];
        if (!itemId)
            continue;
        uint32 needed = quest->RequiredItemCount[i];
        uint32 have   = player->GetItemCount(itemId, true);
        if (have < needed)
            player->AddItem(itemId, needed - have);
    }
}

class mod_quest_helper_player : public PlayerScript
{
public:
    mod_quest_helper_player() : PlayerScript("mod_quest_helper_player") { }

    void OnPlayerLogin(Player* player) override
    {
        if (!sQuestHelperMgr->IsEnabled() || !sQuestHelperMgr->IsWelcomeMessageEnabled())
            return;

        if (player->GetPlayerSetting(QUEST_HELPER_MODULE, SETTING_QH_FLAGS).HasFlag(QH_FLAG_HIDE_MESSAGES))
            return;

        ChatHandler(player->GetSession()).PSendModuleSysMessage(QUEST_HELPER_MODULE, LANG_QUEST_HELPER_WELCOME);
    }

    void OnPlayerQuestAccept(Player* player, Quest const* quest) override
    {
        if (!sQuestHelperMgr->IsEnabled())
            return;

        uint32 questId = quest->GetQuestId();
        uint32 realmId = realm.Id.Realm;

        LOG_DEBUG("module.quest_helper", "QuestHelper: Player {} accepted quest {} ({})",
            player->GetName(), quest->GetTitle(), questId);

        bool isAutoRewarded = sQuestHelperMgr->IsAutoRewarded(questId, realmId);
        bool isAutoComplete = sQuestHelperMgr->IsAutoComplete(questId, realmId);

        if (!player->GetPlayerSetting(QUEST_HELPER_MODULE, SETTING_QH_FLAGS).HasFlag(QH_FLAG_HIDE_MESSAGES))
        {
            ChatHandler handler(player->GetSession());
            if (isAutoRewarded)
                handler.PSendModuleSysMessage(QUEST_HELPER_MODULE, LANG_QUEST_HELPER_AUTO_COMPLETE_REWARD, quest->GetTitle());
            else if (isAutoComplete)
                handler.PSendModuleSysMessage(QUEST_HELPER_MODULE, LANG_QUEST_HELPER_AUTO_COMPLETE, quest->GetTitle());

            for (std::string const& comment : sQuestHelperMgr->GetEnabledComments(questId, realmId))
                handler.PSendModuleSysMessage(QUEST_HELPER_MODULE, LANG_QUEST_HELPER_COMMENT, comment);
        }

        if (isAutoRewarded)
        {
            FulfillQuestObjectives(player, quest);
            player->CompleteQuest(questId);
            player->RewardQuest(quest, 0, player, false);
        }
        else if (isAutoComplete)
        {
            FulfillQuestObjectives(player, quest);
            player->CompleteQuest(questId);
        }
    }
};

class mod_quest_helper_worldscript : public WorldScript
{
public:
    mod_quest_helper_worldscript() : WorldScript("mod_quest_helper_worldscript", {
        WORLDHOOK_ON_AFTER_CONFIG_LOAD
    }) { }

    void OnAfterConfigLoad(bool reload) override
    {
        sQuestHelperMgr->LoadConfig();
        if (!reload)
        {
            sQuestHelperMgr->PurgeUntilRestartFlags();
            sQuestHelperMgr->LoadAutoCompleteQuests();
            sQuestHelperMgr->LoadQuestComments();
        }
    }
};

void AddSC_mod_quest_helper()
{
    new mod_quest_helper_player();
    new mod_quest_helper_worldscript();
}
