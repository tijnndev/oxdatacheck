# FiveM ESX OverExtended Data Check

This FiveM Lua script interacts with the ESX framework to check player inventories for large sums of money (cash or black money). It uses MySQL to query the `ox_inventory` table and log any players with money amounts above a specified threshold.

## Features

- **Inventory Check Command**: The script registers a command `/checkappa` to check the player inventories for money (cash or black money).
- **Custom Threshold**: The script checks if a player has an amount greater than a configurable threshold (defined in `Config.AppartmentCheckAmount`).
- **Ace Permissions**: The command can only be run by players with specific Ace permissions (`oxdc.checkappa` or `oxdc.admin`) or by the console.

## Requirements

- **FiveM**: This script is for FiveM servers running the ESX framework.
- **ESX Framework**: Ensure that the ESX framework is installed and running.
- **MySQL Database**: The script uses MySQL to fetch player inventory data.
- **ox_inventory**: This script specifically checks the `ox_inventory` table for stored player inventories.

## Installation

1. Place the script file (`server.lua`) into your desired resource folder on your server.
2. Add the resource to your `server.cfg` file to ensure the script runs when the server starts.
   ```bash
   ensure your_resource_folder
   ```
3. Configure Ace permissions to allow specific players to run the command. In your `server.cfg`, add:
   ```bash
   add_ace group.admin oxdc.admin allow
   add_ace group.moderator oxdc.checkappa allow 
   ```
4. Set the right values for your server in the `config.lua` file (if used) to define the threshold for your server

## Usage

The script provides several commands for managing and checking player data:

- **Command**: `/checkappa`
  - Checks player appartments for large amounts of cash or black money.
  - **Permission**: `oxdc.checkappa` or `oxdc.admin`
  
- **Command**: `/checkvehicles`
  - Queries and displays information about player-owned vehicles.
  - **Permission**: `oxdc.checkvehicles` or `oxdc.admin`

- **Command**: `/checkmoney [amount of money]`
  - Checks the cash balances of players.
  - **Permission**: `oxdc.checkmoney` or `oxdc.admin`
  
- **Command**: `/wipe [license]`
  - Wipes specific player data (use with caution).
  - **Permission**: `oxdc.wipe` or `oxdc.admin`
  
- **Command**: `/clearoffinv [license]`
  - Clears items from the inventory of offline players.
  - **Permission**: `oxdc.clearoffinv` or `oxdc.admin`
  
- **Command**: `/check [license]`
  - A general check command for specific player data.
  - **Permission**: `oxdc.check` or `oxdc.admin`
  
- **Command**: `/combatlogboete [license]`
  - Issues a penalty for combat logging.
  - **Permission**: `oxdc.combatlogboete` or `oxdc.admin`
  
- **Command**: `/replaceid [old_license] [new_license]`
  - Replaces the player ID in the database.
  - **Permission**: `oxdc.replaceid` or `oxdc.admin`

### Permissions

Only users with specific Ace permissions or the console can run these commands. Ensure that appropriate Ace permissions are set for each command.

## Configuration

The script includes various configuration options to customize its behavior:

- **Config.SteamRequired**:
  This setting enforces that players must be connected via Steam to interact with the server.  
  `true` means Steam is required, `false` allows non-Steam users.

- **Config.WipeTables**:
  A list of database tables that will be wiped when the `/wipe` command is used. This is a destructive action, so use it with caution.
  
- **Config.ServerTables**:
  Defines the tables and the respective columns that are associated with user identifiers. This helps to ensure actions like wiping data are properly mapped across the database.
  
- **Config.AppartmentCheckAmount**:
  The threshold for how much money (cash or black money) a player can have in their apartment before being flagged.
  
- **Config.GloveBoxCheckAmount**:
  The threshold for how much money (cash or black money) a player can store in their glove box before being flagged.
  
- **Config.CombatlogBoete**:
  The penalty (in money) issued to players who are caught combat logging.
  
- **Config.CombatlogBoeteWebhook**:
  The Discord webhook URL used to log combat log penalties.
  
- **Config.ClearOffInvWebhook**:
  The Discord webhook URL used to log when an offline player's inventory is cleared.
  
- **Config.WipeLogsWebhook**:
  The Discord webhook URL used to log when a wipe command is executed.