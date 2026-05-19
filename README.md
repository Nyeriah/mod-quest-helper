# Mod-Quest-Helper

## What is this module?

Quest Helper is a per-realm tool for server administrators to flag quests that are known to have issues.
When a player accepts a flagged quest they receive an automatic in-game notification letting them know
the server is aware of the problem, so they are never left wondering why a quest is broken.

Optionally, the flag can also auto-complete the quest and grant its reward automatically, so players
are not permanently blocked by a broken quest.

Administrators can also attach freeform comments to any quest. Comments are shown to the player in blue
on quest accept and support multiple entries per quest, with the ability to hide individual comments
without deleting them.

### Auto-completion flags

The `flag` field is a bitmask. The lower two bits define the completion behaviour; bit 2 is an optional
modifier that makes the entry temporary:

| Bits | Value | Behaviour |
|------|-------|-----------|
| `0x01` | `1` | Quest will be automatically completed |
| `0x02` | `2` | Quest will be automatically completed **and** rewarded |
| `0x04` | `4` | Modifier: entry is deleted from the database on the next server restart |

Combine the modifier with a behaviour bit using `.qh addtemp` (values 5 or 6 are stored). GMs never
need to set raw bitmask values — the commands handle the combination automatically.

## Requirements

- [AzerothCore](https://github.com/azerothcore/azerothcore-wotlk) — latest master
- `EnablePlayerSettings = 1` in your `worldserver.conf` (required for per-player notification preferences)

## Installation

1. Clone or copy this module into your `modules/` directory:
   ```bash
   cd path/to/azerothcore/modules
   git clone https://github.com/Nyeriah/mod-quest-helper.git
   ```

2. Re-run CMake and rebuild AzerothCore.

3. Apply the SQL files:
   - `data/sql/db-auth/base/quest_completer_quests.sql` → **auth** database
   - `data/sql/db-auth/base/quest_helper_comments.sql` → **auth** database
   - `data/sql/db-world/updates/quest_helper_strings_commands.sql` → **world** database

   **Existing installations** — also apply the auth migration:
   - `data/sql/db-auth/updates/realm_id_allow_negative.sql` → **auth** database

4. Copy `conf/mod-quest-helper.conf.dist` to your server's `etc/` folder, rename it to
   `mod-quest-helper.conf`, and enable the module:
   ```
   QuestHelper.Enable = 1
   ```

## Configuration

| Option | Default | Description |
|--------|---------|-------------|
| `QuestHelper.Enable` | `0` | Enable or disable the module |
| `QuestHelper.WelcomeMessage.Enable` | `1` | Show a welcome message to players on login explaining Quest Helper is active |

## Commands

Quest arguments (`$quest`) accept either a numeric quest ID or a shift-clicked quest link from the
in-game quest log.

### Player commands

| Command | Description |
|---------|-------------|
| `.qh help` | Toggle Quest Helper notifications on/off |
| `.qh help on` | Enable Quest Helper notifications |
| `.qh help off` | Disable Quest Helper notifications |

### GM commands (SEC_MODERATOR+)

| Command | Description |
|---------|-------------|
| `.qh info <quest> [realmId]` | Show the Quest Helper status for a quest: flag, temporary indicator, reason, and active notes. `realmId` defaults to the current realm. |
| `.qh add <quest> <flag> [realmId] [reason]` | Register a quest for auto-completion permanently. `flag`: `1` = complete, `2` = complete and reward. `realmId` defaults to the current realm; use `-1` for all realms. If the quest is already registered with a different flag, the flag is updated in place. |
| `.qh addtemp <quest> <flag> [realmId] [reason]` | Same as `.qh add` but the entry is automatically deleted on the next server restart. |
| `.qh remove <quest> [realmId]` | Remove a quest from the auto-complete list. Confirms the flag that was removed. `realmId` defaults to the current realm. |
| `.qh reload` | Reload all auto-complete quests and comments from the database without restarting. |
| `.qh comment add <quest> [realmId] <comment>` | Attach a comment to a quest. Multiple comments per quest are supported. The assigned comment ID is printed on success. `realmId` defaults to the current realm; use `-1` for all realms. |
| `.qh comment remove <commentId>` | Permanently delete a comment by its ID. |
| `.qh comment hide <commentId>` | Suppress a comment without deleting it (`enabled = 0`). |

### Realm ID

Most GM commands accept an optional `realmId` parameter:

- Omitted → uses the current realm.
- A positive integer → targets that specific realm only.
- `-1` → stored as a universal entry that applies to the current realm on any server that loads it,
  matching the convention used by AzerothCore's RBAC system.

### Re-adding a quest

`.qh add` and `.qh addtemp` check whether the quest is already registered before writing to the
database:

- **Same flag** — the command reports the quest is already registered and makes no changes.
- **Different flag** — the existing entry is updated in place and the old and new flags are reported.

## Database

All data is stored in the **auth** database, making it available across all realms in a multi-realm setup.

### `quest_completer_quests`

Stores quests flagged for auto-completion.

| Column | Type | Description |
|--------|------|-------------|
| `questId` | `int unsigned` | Quest template ID |
| `flag` | `tinyint unsigned` | Bitmask: `0x01` = complete, `0x02` = complete+reward, `0x04` = delete on next restart |
| `realmId` | `int` | Realm ID from `realmlist.id`; `-1` = applies to the current realm on any server |
| `reason` | `varchar(255)` | Optional note explaining why the quest is flagged |

### `quest_helper_comments`

Stores GM comments shown to players on quest accept. A quest may have any number of comments.

| Column | Type | Description |
|--------|------|-------------|
| `id` | `int unsigned` | Auto-increment comment ID, used by hide/remove commands |
| `questId` | `int unsigned` | Quest template ID |
| `realmId` | `int` | Realm ID from `realmlist.id`; `-1` = applies to the current realm on any server |
| `comment` | `varchar(500)` | Text displayed to the player on quest accept |
| `enabled` | `tinyint unsigned` | `1` = active, `0` = hidden |

## Authors

- [Nyeriah](https://github.com/Nyeriah)
