Config = {}

Config.SteamRequired = true
Config.WipeTables = {"users", "billing", "outfits", "owned_vehicles", "appartments", "addon_account_data", "ox_inventory"}

Config.ServerTables = {
    {table = "users", user_column = "identifier"},
    {table = "ox_inventory", user_column = "owner"},
    {table = "owned_vehicles", user_column = "owner"},
    {table = "outfits", user_column = "identifier"},
}

Config.AppartmentCheckAmount = 2000000
Config.GloveBoxCheckAmount = 1000000

Config.CombatlogBoete = 1000000
Config.CombatlogBoeteWebook = ''
Config.ClearOffInvWebhook = ''
Config.WipeLogsWebhook = ''