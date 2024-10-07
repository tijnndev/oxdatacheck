Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/checkappa', 'Check player inventories for large amounts of cash or black money.', {})
    TriggerEvent('chat:addSuggestion', '/checkvehicles', 'Query and display information about player-owned vehicles.', {})
    TriggerEvent('chat:addSuggestion', '/checkmoney', 'Check the cash balances of players.', {})
    TriggerEvent('chat:addSuggestion', '/wipe', 'Wipe specific player data (use with caution).', {
        { name = "player-license", help = "license of the player to wipe" }
    })
    TriggerEvent('chat:addSuggestion', '/clearoffinv', 'Clear items from the inventory of offline players.', {
        { name = "player-license", help = "license of the offline player" }
    })
    TriggerEvent('chat:addSuggestion', '/check', 'A general check command for specific player data.', {
        { name = "player-license", help = "license of the player to check" }
    })
    TriggerEvent('chat:addSuggestion', '/combatlogboete', 'Issue a penalty for combat logging.', {
        { name = "player-license", help = "License of the player to penalize" }
    })
    TriggerEvent('chat:addSuggestion', '/replaceid', 'Replace the player ID in the database.', {
        { name = "old-license", help = "The old player license" },
        { name = "new-license", help = "The new player license" }
    })
end)