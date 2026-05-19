/*
 * Copyright (C) 2016+ AzerothCore <www.azerothcore.org>, released under GNU AGPL v3 license: https://github.com/azerothcore/azerothcore-wotlk/blob/master/LICENSE-AGPL3
 */

#include "Chat.h"
#include "Player.h"
#include "PlayerSettings.h"
#include "Realm.h"
#include "ScriptMgr.h"
#include "World.h"
#include "QuestHelperMgr.h"

using namespace Acore::ChatCommands;

class quest_helper_commandscript : public CommandScript
{
public:
    quest_helper_commandscript() : CommandScript("quest_helper_commandscript") { }

    ChatCommandTable GetCommands() const override
    {
        static ChatCommandTable commentTable =
        {
            { "add",    HandleQuestHelperCommentAddCommand,    SEC_MODERATOR, Console::Yes },
            { "remove", HandleQuestHelperCommentRemoveCommand, SEC_MODERATOR, Console::Yes },
            { "hide",   HandleQuestHelperCommentHideCommand,   SEC_MODERATOR, Console::Yes },
        };
        static ChatCommandTable qhTable =
        {
            { "help",    HandleQuestHelperHelpCommand,    SEC_PLAYER,    Console::No  },
            { "info",    HandleQuestHelperInfoCommand,    SEC_MODERATOR, Console::Yes },
            { "add",     HandleQuestHelperAddCommand,     SEC_MODERATOR, Console::Yes },
            { "addtemp", HandleQuestHelperAddTempCommand, SEC_MODERATOR, Console::Yes },
            { "remove",  HandleQuestHelperRemoveCommand,  SEC_MODERATOR, Console::Yes },
            { "reload",  HandleQuestHelperReloadCommand,  SEC_MODERATOR, Console::Yes },
            { "comment", commentTable },
        };
        static ChatCommandTable commandTable =
        {
            { "qh", qhTable },
        };
        return commandTable;
    }

    static bool HandleQuestHelperHelpCommand(ChatHandler* handler, Optional<bool> enable)
    {
        Player* player = handler->GetSession()->GetPlayer();
        PlayerSetting setting = player->GetPlayerSetting(QUEST_HELPER_MODULE, SETTING_QH_FLAGS);

        // If no argument is provided, toggle the current state
        bool showMessages = enable.has_value() ? *enable : setting.HasFlag(QH_FLAG_HIDE_MESSAGES);

        if (showMessages)
            setting.RemoveFlag(QH_FLAG_HIDE_MESSAGES);
        else
            setting.AddFlag(QH_FLAG_HIDE_MESSAGES);

        player->UpdatePlayerSetting(QUEST_HELPER_MODULE, SETTING_QH_FLAGS, setting.value);

        handler->PSendModuleSysMessage(QUEST_HELPER_MODULE,
            showMessages ? LANG_QUEST_HELPER_MESSAGES_ON : LANG_QUEST_HELPER_MESSAGES_OFF);
        return true;
    }

    static bool HandleQuestHelperInfoCommand(ChatHandler* handler, Quest const* quest, Optional<int32> realmId)
    {
        uint32 questId = quest->GetQuestId();
        int32 targetRealm = realmId.value_or(static_cast<int32>(realm.Id.Realm));
        QuestEntry const* entry = sQuestHelperMgr->GetQuestEntry(questId, targetRealm);

        if (!entry)
        {
            handler->PSendModuleSysMessage(QUEST_HELPER_MODULE, LANG_QUEST_HELPER_INFO_NOT_FLAGGED,
                questId, quest->GetTitle(), targetRealm);
            return true;
        }

        if (entry->flag == QUEST_AUTO_FLAG_COMPLETE_REWARD)
            handler->PSendModuleSysMessage(QUEST_HELPER_MODULE, LANG_QUEST_HELPER_INFO_AUTO_COMPLETE_REWARD,
                questId, quest->GetTitle(), targetRealm);
        else
            handler->PSendModuleSysMessage(QUEST_HELPER_MODULE, LANG_QUEST_HELPER_INFO_AUTO_COMPLETE,
                questId, quest->GetTitle(), targetRealm);

        if (entry->flag & QUEST_AUTO_FLAG_UNTIL_RESTART)
            handler->PSendModuleSysMessage(QUEST_HELPER_MODULE, LANG_QUEST_HELPER_INFO_TEMP);

        if (!entry->reason.empty())
            handler->PSendModuleSysMessage(QUEST_HELPER_MODULE, LANG_QUEST_HELPER_INFO_REASON, entry->reason);

        for (std::string const& comment : sQuestHelperMgr->GetEnabledComments(questId, targetRealm))
            handler->PSendModuleSysMessage(QUEST_HELPER_MODULE, LANG_QUEST_HELPER_COMMENT, comment);

        return true;
    }

    static bool HandleQuestHelperAddCommand(ChatHandler* handler, Quest const* quest, uint8 flag, Optional<int32> realmId, Tail reason)
    {
        if (flag != QUEST_AUTO_FLAG_COMPLETE && flag != QUEST_AUTO_FLAG_COMPLETE_REWARD)
        {
            handler->PSendModuleSysMessage(QUEST_HELPER_MODULE, LANG_QUEST_HELPER_CMD_INVALID_FLAG);
            handler->SetSentErrorMessage(true);
            return false;
        }

        uint32 questId    = quest->GetQuestId();
        int32 targetRealm = realmId.value_or(static_cast<int32>(realm.Id.Realm));

        QuestEntry const* existing = sQuestHelperMgr->GetQuestEntry(questId, targetRealm);
        if (existing)
        {
            if (existing->flag == flag)
            {
                handler->PSendModuleSysMessage(QUEST_HELPER_MODULE, LANG_QUEST_HELPER_CMD_QUEST_ALREADY_REGISTERED,
                    questId, quest->GetTitle(), targetRealm, uint32(flag));
                return true;
            }

            uint8 oldFlag = existing->flag;
            sQuestHelperMgr->AddAutoCompleteQuest(questId, flag, targetRealm, std::string(reason));
            handler->PSendModuleSysMessage(QUEST_HELPER_MODULE, LANG_QUEST_HELPER_CMD_QUEST_FLAG_UPDATED,
                questId, quest->GetTitle(), targetRealm, uint32(oldFlag), uint32(flag));
            return true;
        }

        sQuestHelperMgr->AddAutoCompleteQuest(questId, flag, targetRealm, std::string(reason));
        handler->PSendModuleSysMessage(QUEST_HELPER_MODULE, LANG_QUEST_HELPER_CMD_QUEST_ADDED,
            questId, quest->GetTitle(), uint32(flag), targetRealm);
        return true;
    }

    static bool HandleQuestHelperAddTempCommand(ChatHandler* handler, Quest const* quest, uint8 flag, Optional<int32> realmId, Tail reason)
    {
        if (flag != QUEST_AUTO_FLAG_COMPLETE && flag != QUEST_AUTO_FLAG_COMPLETE_REWARD)
        {
            handler->PSendModuleSysMessage(QUEST_HELPER_MODULE, LANG_QUEST_HELPER_CMD_INVALID_FLAG);
            handler->SetSentErrorMessage(true);
            return false;
        }

        uint32 questId      = quest->GetQuestId();
        int32 targetRealm   = realmId.value_or(static_cast<int32>(realm.Id.Realm));
        uint8 newFlag       = flag | QUEST_AUTO_FLAG_UNTIL_RESTART;

        QuestEntry const* existing = sQuestHelperMgr->GetQuestEntry(questId, targetRealm);
        if (existing)
        {
            if (existing->flag == newFlag)
            {
                handler->PSendModuleSysMessage(QUEST_HELPER_MODULE, LANG_QUEST_HELPER_CMD_QUEST_ALREADY_REGISTERED,
                    questId, quest->GetTitle(), targetRealm, uint32(flag));
                return true;
            }

            uint8 oldFlag = existing->flag;
            sQuestHelperMgr->AddAutoCompleteQuest(questId, newFlag, targetRealm, std::string(reason));
            handler->PSendModuleSysMessage(QUEST_HELPER_MODULE, LANG_QUEST_HELPER_CMD_QUEST_FLAG_UPDATED,
                questId, quest->GetTitle(), targetRealm, uint32(oldFlag), uint32(flag));
            return true;
        }

        sQuestHelperMgr->AddAutoCompleteQuest(questId, newFlag, targetRealm, std::string(reason));
        handler->PSendModuleSysMessage(QUEST_HELPER_MODULE, LANG_QUEST_HELPER_CMD_QUEST_ADDED_TEMP,
            questId, quest->GetTitle(), uint32(flag), targetRealm);
        return true;
    }

    static bool HandleQuestHelperRemoveCommand(ChatHandler* handler, Quest const* quest, Optional<int32> realmId)
    {
        uint32 questId    = quest->GetQuestId();
        int32 targetRealm = realmId.value_or(static_cast<int32>(realm.Id.Realm));

        QuestEntry const* entry = sQuestHelperMgr->GetQuestEntry(questId, targetRealm);
        if (!entry)
        {
            handler->PSendModuleSysMessage(QUEST_HELPER_MODULE, LANG_QUEST_HELPER_CMD_QUEST_NOT_REGISTERED,
                questId, quest->GetTitle(), targetRealm);
            handler->SetSentErrorMessage(true);
            return false;
        }

        uint8 removedFlag = entry->flag;
        sQuestHelperMgr->RemoveAutoCompleteQuest(questId, targetRealm);
        handler->PSendModuleSysMessage(QUEST_HELPER_MODULE, LANG_QUEST_HELPER_CMD_QUEST_REMOVED,
            questId, quest->GetTitle(), uint32(removedFlag), targetRealm);
        return true;
    }

    static bool HandleQuestHelperReloadCommand(ChatHandler* handler)
    {
        sQuestHelperMgr->PurgeUntilRestartFlags();
        sQuestHelperMgr->LoadAutoCompleteQuests();
        sQuestHelperMgr->LoadQuestComments();
        handler->PSendModuleSysMessage(QUEST_HELPER_MODULE, LANG_QUEST_HELPER_CMD_RELOADED);
        return true;
    }

    static bool HandleQuestHelperCommentAddCommand(ChatHandler* handler, Quest const* quest, Optional<int32> realmId, Tail comment)
    {
        if (comment.empty())
            return false;

        uint32 questId    = quest->GetQuestId();
        int32 targetRealm = realmId.value_or(static_cast<int32>(realm.Id.Realm));
        uint32 commentId = sQuestHelperMgr->AddQuestComment(questId, targetRealm, std::string(comment));

        handler->PSendModuleSysMessage(QUEST_HELPER_MODULE, LANG_QUEST_HELPER_CMD_COMMENT_ADDED,
            commentId, questId, quest->GetTitle(), targetRealm);
        return true;
    }

    static bool HandleQuestHelperCommentRemoveCommand(ChatHandler* handler, uint32 commentId)
    {
        if (!sQuestHelperMgr->RemoveQuestComment(commentId))
        {
            handler->PSendModuleSysMessage(QUEST_HELPER_MODULE, LANG_QUEST_HELPER_CMD_COMMENT_NOT_FOUND, commentId);
            handler->SetSentErrorMessage(true);
            return false;
        }

        handler->PSendModuleSysMessage(QUEST_HELPER_MODULE, LANG_QUEST_HELPER_CMD_COMMENT_REMOVED, commentId);
        return true;
    }

    static bool HandleQuestHelperCommentHideCommand(ChatHandler* handler, uint32 commentId)
    {
        if (!sQuestHelperMgr->HideQuestComment(commentId))
        {
            handler->PSendModuleSysMessage(QUEST_HELPER_MODULE, LANG_QUEST_HELPER_CMD_COMMENT_NOT_FOUND, commentId);
            handler->SetSentErrorMessage(true);
            return false;
        }

        handler->PSendModuleSysMessage(QUEST_HELPER_MODULE, LANG_QUEST_HELPER_CMD_COMMENT_HIDDEN, commentId);
        return true;
    }
};

void AddSC_quest_helper_commandscript()
{
    new quest_helper_commandscript();
}
