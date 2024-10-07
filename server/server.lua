ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterCommand(
    "checkappa",
    function(source, args, rawCommand)
        if source == 0 or IsPlayerAceAllowed(source, "oxdc.checkappa") or IsPlayerAceAllowed(source, "oxdc.admin") then
            MySQL.Async.fetchAll(
                "SELECT * FROM ox_inventory",
                {},
                function(result)
                    for _, row in ipairs(result) do
                        local inventoryData = json.decode(row.data)
                        if inventoryData then
                            for _, item in ipairs(inventoryData) do
                                if item.count > Config.AppartmentCheckAmount and item.name == "money" or item.name == "black_money" and item.count > Config.AppartmentCheckAmount then
                                    print(row.owner .. ": " .. item.count)
                                end
                            end
                        end
                    end
                end
            )
        else
            TriggerClientEvent(
                "chat:addMessage",
                source,
                {
                    args = {"Server", "You do not have permission to use this command."}
                }
            )
        end
    end,
    false
)

RegisterCommand(
    "checkvehicles",
    function(source, args, rawCommand)
        if source == 0 or IsPlayerAceAllowed(source, "oxdc.checkvehicles") or IsPlayerAceAllowed(source, "oxdc.admin") then
            MySQL.Async.fetchAll(
                "SELECT owner, glovebox, trunk FROM owned_vehicles",
                {},
                function(result)
                    for _, vehicle in ipairs(result) do
                        local gloveboxMoney = 0
                        local trunkMoney = 0

                        local gloveboxItems = json.decode(vehicle.glovebox)
                        if gloveboxItems then
                            for _, item in ipairs(gloveboxItems) do
                                if item.name == "money" or item.name == "black_money" then
                                    gloveboxMoney = gloveboxMoney + item.count
                                end
                            end
                        end

                        local trunkItems = json.decode(vehicle.trunk)
                        if trunkItems then
                            for _, item in ipairs(trunkItems) do
                                if item.name == "money" or item.name == "black_money" then
                                    trunkMoney = trunkMoney + item.count
                                end
                            end
                        end

                        local totalMoney = gloveboxMoney + trunkMoney
                        if totalMoney > Config.GloveBoxCheckAmount then
                            print("Vehicle Owner: " .. vehicle.owner .. " has " .. totalMoney .. " in money items.")
                            if source ~= 0 then
                                TriggerClientEvent(
                                    "chat:addMessage",
                                    source,
                                    {
                                        args = {
                                            "Server",
                                            "Vehicle Owner: " .. vehicle.owner .. " has " .. totalMoney .. " in money items."
                                        }
                                    }
                                )
                            end
                        end
                    end
                end
            )
        else
            TriggerClientEvent(
                "chat:addMessage",
                source,
                {
                    args = {"Server", "You do not have permission to use this command."}
                }
            )
        end
    end,
    false
)

RegisterCommand(
    "checkmoney",
    function(source, args, rawCommand)
        if source == 0 or IsPlayerAceAllowed(source, "oxdc.checkmoney") or IsPlayerAceAllowed(source, "oxdc.admin") then
            local amount = tonumber(args[1])
            if not amount then
                if source == 0 then
                    print("Please provide a valid number as argument.")
                    return
                end
                TriggerClientEvent(
                    "chat:addMessage",
                    source,
                    {
                        args = {"Server", "Please provide a valid number as argument."}
                    }
                )
                return
            end

            MySQL.Async.fetchAll(
                "SELECT * FROM users",
                {},
                function(result)
                    for _, row in ipairs(result) do
                        local inventoryData = json.decode(row.accounts)
                        if inventoryData then
                            local valueEnd = 0
                            for key, value in pairs(inventoryData) do
                                valueEnd = valueEnd + value
                            end
                            if valueEnd > amount then
                                print(row.identifier .. ": " .. valueEnd)
                            end
                        end
                    end
                end
            )
        else
            TriggerClientEvent(
                "chat:addMessage",
                source,
                {
                    args = {"Server", "You do not have permission to use this command."}
                }
            )
        end
    end,
    false
)

RegisterCommand(
    "wipe",
    function(source, args, rawCommand)
        if source == 0 or IsPlayerAceAllowed(source, "oxdc.wipe") or IsPlayerAceAllowed(source, "oxdc.admin") then
            local identifier = args[1]
            if not identifier or identifier == "" then
                print("Usage: /wipe [identifier]")
                return
            end

            local tablesToCheck = Config.WipeTables
            for _, tableName in ipairs(tablesToCheck) do
                local queries = {
                    {
                        query = string.format("SELECT * FROM `%s` WHERE identifier LIKE '%%%s%%'", tableName, identifier),
                        type = "identifier"
                    },
                    {
                        query = string.format("SELECT * FROM `%s` WHERE owner LIKE '%%%s%%'", tableName, identifier),
                        type = "owner"
                    }
                }

                for _, q in ipairs(queries) do
                    MySQL.Async.fetchAll(
                        q.query,
                        {},
                        function(result)
                            if result and #result > 0 then
                                print(
                                    string.format(
                                        "Would delete %d entries from %s for %s %s",
                                        #result,
                                        tableName,
                                        q.type,
                                        identifier
                                    )
                                )
                                TriggerEvent(
                                    "td_logs:sendLog",
                                    Config.WipeLogsWebhook,
                                    source or -1,
                                    {
                                        title = string.format(
                                            "Deleted %d entries from %s for %s %s",
                                            #result,
                                            tableName,
                                            q.type,
                                            identifier
                                        ),
                                        desc = string.format(
                                            "Deleted %d entries from %s for %s %s",
                                            #result,
                                            tableName,
                                            q.type,
                                            identifier
                                        )
                                    }
                                )
                                MySQL.Async.execute(
                                    string.format("DELETE FROM `%s` WHERE %s LIKE '%%%s%%'", tableName, q.type, identifier),
                                    {}
                                )
                            else
                                print(string.format("No entries found in %s for %s %s", tableName, q.type, identifier))
                                TriggerEvent(
                                    "td_logs:sendLog",
                                    Config.WipeLogsWebhook,
                                    source,
                                    {
                                        title = string.format(
                                            "No entries found in %s for %s %s",
                                            tableName,
                                            q.type,
                                            identifier
                                        ),
                                        desc = string.format(
                                            "No entries found in %s for %s %s",
                                            tableName,
                                            q.type,
                                            identifier
                                        )
                                    },
                                    0x000001
                                )
                            end
                        end
                    )
                end
            end
        else
            print("You don't have permission to use this command.")
        end
    end,
    false
)


RegisterCommand(
    "clearoffinv",
    function(source, args, rawCommand)
        if source == 0 or IsPlayerAceAllowed(source, "oxdc.clearoffinv") or IsPlayerAceAllowed(source, "oxdc.admin") then
            local identifier = args[1]
            if identifier then
                local fetchQuery = "SELECT inventory FROM users WHERE identifier = @identifier"
                MySQL.Async.fetchScalar(
                    fetchQuery,
                    {["@identifier"] = identifier},
                    function(oldInventory)
                        if oldInventory then
                            print("Old Inventory for [" .. identifier .. "]: " .. oldInventory)

                            local updateQuery = "UPDATE users SET inventory = '{}' WHERE identifier = @identifier"
                            MySQL.Async.execute(
                                updateQuery,
                                {["@identifier"] = identifier},
                                function(affectedRows)
                                    if affectedRows > 0 then
                                        print("[" .. identifier .. "] Inventory has been reset.")
                                        if source ~= 0 then
                                            TriggerClientEvent(
                                                "chat:addMessage",
                                                source,
                                                {
                                                    args = {
                                                        "Server",
                                                        "Inventory has been reset for identifier: " .. identifier
                                                    }
                                                }
                                            )
                                        end
                                        local user = "console"
                                        if source > 0 then
                                            user = GetPlayerName(source)
                                        end
                                        TriggerEvent(
                                            "td_logs:sendLogNoFields",
                                            Config.ClearOffInvWebhook,
                                            {
                                                title = identifier .. " zijn inventory is zojuist gecleared door " .. user,
                                                desc = "Oude Inventory: " .. json.encode(oldInventory)
                                            },
                                            0xffffff
                                        )
                                    else
                                        print("No user found with that identifier or unable to reset inventory.")
                                        if source ~= 0 then
                                            TriggerClientEvent(
                                                "chat:addMessage",
                                                source,
                                                {
                                                    args = {
                                                        "Server",
                                                        "No user found with that identifier or unable to reset inventory."
                                                    }
                                                }
                                            )
                                        end
                                    end
                                end
                            )
                        else
                            print("No inventory found for identifier: " .. identifier)
                            if source ~= 0 then
                                TriggerClientEvent(
                                    "chat:addMessage",
                                    source,
                                    {
                                        args = {"Server", "No inventory found for identifier: " .. identifier}
                                    }
                                )
                            end
                        end
                    end
                )
            else
                if source ~= 0 then
                    TriggerClientEvent(
                        "chat:addMessage",
                        source,
                        {
                            args = {"Server", "You must provide an identifier."}
                        }
                    )
                else
                    print("You must provide an identifier.")
                end
            end
        else
            if source ~= 0 then
                TriggerClientEvent(
                    "chat:addMessage",
                    source,
                    {
                        args = {"Server", "You do not have permission to use this command."}
                    }
                )
            end
        end
    end,
    false
)

RegisterCommand(
    "check",
    function(source, args, rawCommand)
        if source == 0 or IsPlayerAceAllowed(source, "oxdc.check") or IsPlayerAceAllowed(source, "oxdc.admin") then
            if not args[1] then
                print("You must provide an identifier.")
                return
            end

            local identifier = args[1]

            MySQL.Async.fetchAll(
                "SELECT * FROM users WHERE identifier = @identifier",
                {["@identifier"] = identifier},
                function(usersResult)
                    for _, row in ipairs(usersResult) do
                        print("Name: " .. row.firstname .. " " .. row.lastname)
                        local accountsData = json.decode(row.accounts)
                        if accountsData then
                            local totalBalance = 0
                            for _, balance in pairs(accountsData) do
                                totalBalance = totalBalance + balance
                            end
                            print("Accounts (" .. identifier .. "): " .. totalBalance)
                        end
                    end
                end
            )
            MySQL.Async.fetchAll(
                "SELECT * FROM ox_inventory WHERE owner = @owner",
                {["@owner"] = identifier},
                function(inventoryResult)
                    for _, row in ipairs(inventoryResult) do
                        local inventoryData = json.decode(row.data)
                        if inventoryData then
                            for _, item in ipairs(inventoryData) do
                                if item.name == "money" or item.name == "black_money" then
                                    print("(" .. row.name .. "): " .. item.count)
                                end
                            end
                        end
                    end
                end
            )

            MySQL.Async.fetchAll(
                "SELECT owner, plate, glovebox, trunk FROM owned_vehicles WHERE owner = @owner",
                {["@owner"] = identifier},
                function(vehicleResult)
                    for _, vehicle in ipairs(vehicleResult) do
                        local gloveboxMoney = 0
                        local trunkMoney = 0

                        local gloveboxItems = json.decode(vehicle.glovebox)
                        if gloveboxItems then
                            for _, item in ipairs(gloveboxItems) do
                                if item.name == "money" or item.name == "black_money" then
                                    gloveboxMoney = gloveboxMoney + item.count
                                end
                            end
                        end

                        local trunkItems = json.decode(vehicle.trunk)
                        if trunkItems then
                            for _, item in ipairs(trunkItems) do
                                if item.name == "money" or item.name == "black_money" then
                                    trunkMoney = trunkMoney + item.count
                                end
                            end
                        end
                        local totalMoney = gloveboxMoney + trunkMoney
                        print("Vehicles " .. vehicle.plate .. ": " .. totalMoney)
                    end
                end
            )
        else
            print("You do not have permission to use this command.")
        end
    end,
    false
)

-- =========================
-- COMBATLOG BOETE
-- =========================
RegisterCommand(
    "combatlogboete",
    function(source, args, rawCommand)
        if source == 0 or IsPlayerAceAllowed(source, "oxdc.combatlogboete") or IsPlayerAceAllowed(source, "oxdc.admin") then
            if not args[1] then
                print("You must provide an identifier.")
                return
            end

            local identifier = args[1]
            MySQL.Async.fetchScalar(
                "SELECT accounts FROM users WHERE identifier = @identifier",
                {
                    ["@identifier"] = identifier
                },
                function(accountsJson)
                    if accountsJson then
                        local accounts = json.decode(accountsJson)
                        if accounts and accounts.bank then
                            accounts.bank = accounts.bank - Config.CombatlogBoete
                            local updatedAccountsJson = json.encode(accounts)

                            MySQL.Async.execute(
                                "UPDATE users SET accounts = @accounts WHERE identifier = @identifier",
                                {
                                    ["@accounts"] = updatedAccountsJson,
                                    ["@identifier"] = identifier
                                },
                                function(rowsChanged)
                                    if rowsChanged > 0 then
                                        print("Combatlog boete toegepast!")
                                        local user = "console"
                                        if source > 0 then
                                            user = GetPlayerName(source)
                                        end
                                        TriggerEvent(
                                            "td_logs:sendLogNoFields",
                                            Config.CombatlogBoeteWebook,
                                            {
                                                title = identifier .. " heeft zojuist een combatlogboete ontvangen van " .. user,
                                                desc = "Nieuwe Bankwaarde: " .. accounts.bank
                                            },
                                            0xffffff
                                        )
                                    else
                                        print("Combatlog boete mislukt.")
                                    end
                                end
                            )
                        else
                            print("Failed to parse accounts JSON or bank field is missing")
                        end
                    else
                        print("No user found with the specified identifier")
                    end
                end
            )
        else
            print("You do not have permission to use this command.")
        end
    end,
    false
)


-- =========================
-- STEAM REQUIRED
-- =========================
AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    deferrals.defer()

    local src = source
    local identifiers = GetPlayerIdentifiers(src)
    local steamID = nil

    for _, identifier in ipairs(identifiers) do
        if string.find(identifier, 'steam:') then
            steamID = identifier
            break
        end
    end

    if not steamID and Config.SteamRequired then
        setKickReason('You must have Steam connected to play on this server.')
        deferrals.done('You must have Steam connected to play on this server.')
    else
        deferrals.done()
    end
end)


-- =========================
-- SET OFFLINE JOB
-- =========================
RegisterCommand('setofflinejob', function(source, args, rawCommand)
    if source == 0 or IsPlayerAceAllowed(source, "oxdc.setofflinejob") or IsPlayerAceAllowed(source, "oxdc.admin") then
        TriggerClientEvent('chat:addMessage', source, {
            args = { 'System', 'You do not have the right permissions to execute this command.' }
        })
        return
    end

    if #args < 3 then
        if source == 0 then
            print('Usage: /setjob [identifier] [job] [job_grade]')
        else
            TriggerClientEvent('chat:addMessage', source, {
                args = { 'System', 'Usage: /setjob [identifier] [job] [job_grade]' }
            })
        end
        return
    end

    local identifier = args[1]
    local job = args[2]
    local jobGrade = tonumber(args[3])

    if not jobGrade or jobGrade < 0 then
        if source == 0 then
            print('Job grade must be a positive number.')
        else
            TriggerClientEvent('chat:addMessage', source, {
                args = { 'System', 'Job grade must be a positive number.' }
            })
        end
        return
    end

    local query = 'UPDATE users SET job = @job, job_grade = @job_grade WHERE identifier = @identifier'
    local parameters = {
        ['@job'] = job,
        ['@job_grade'] = jobGrade,
        ['@identifier'] = identifier
    }

    MySQL.Async.execute(query, parameters, function(rowsChanged)
        if rowsChanged > 0 then
            if source == 0 then
                print(('Job and job grade updated for identifier %s'):format(identifier))
            else
                TriggerClientEvent('chat:addMessage', source, {
                    args = { 'System', ('Job and job grade updated for identifier %s'):format(identifier) }
                })
            end
        else
            if source == 0 then
                print(('No user found with identifier %s'):format(identifier))
            else
                TriggerClientEvent('chat:addMessage', source, {
                    args = { 'System', ('No user found with identifier %s'):format(identifier) }
                })
            end
        end
    end)
end, false)


-- ==================================================
-- AFTER PC RESET, REPLACE USER ID TO KEEP ITEMS
-- ==================================================
RegisterCommand("replaceid", function(source, args, rawCommand)
    if source ~= 0 then
        print("This command can only be run from the console or an admin!")
        return
    end

    local oldIdentifier = args[1]
    local newIdentifier = args[2]

    if not oldIdentifier or not newIdentifier then
        print("Usage: /replaceid [oldIdentifier] [newIdentifier]")
        return
    end

    local tables = Config.ServerTables

    for _, tableData in ipairs(tables) do
        local tableName = tableData.table
        local columnName = tableData.user_column

        local query = string.format("UPDATE `%s` SET `%s` = @newIdentifier WHERE `%s` = @oldIdentifier", tableName, columnName, columnName)

        MySQL.Async.execute(query, {
            ['@newIdentifier'] = newIdentifier,
            ['@oldIdentifier'] = oldIdentifier
        }, function(affectedRows)
            if affectedRows > 0 then
                print(string.format("Updated %d rows in table '%s'", affectedRows, tableName))
            else
                print(string.format("No rows found in table '%s' with identifier '%s'", tableName, oldIdentifier))
            end
        end)
    end

    print(string.format("Replaced identifier '%s' with '%s' in all specified tables.", oldIdentifier, newIdentifier))
end, true)
