local ESX = exports['es_extended']:getSharedObject()

-- Check if player can afford ticket
ESX.RegisterServerCallback('esx_trains:canBuyTicket', function(source, cb, ticketType)
    local xPlayer = ESX.GetPlayerFromId(source)
    local price = Config.TicketSystem.prices[ticketType]
    
    if xPlayer.getMoney() >= price then
        xPlayer.removeMoney(price)
        cb(true)
    else
        cb(false)
    end
end)

-- Issue fine to player
RegisterServerEvent('esx_trains:issueFine')
AddEventHandler('esx_trains:issueFine', function(amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if xPlayer then
        xPlayer.removeAccountMoney('bank', amount)
        TriggerClientEvent('esx:showNotification', source, 'You have been fined $' .. amount .. ' for not having a valid ticket')
    end
end)

-- Sync tickets between clients
RegisterServerEvent('esx_trains:syncTicket')
AddEventHandler('esx_trains:syncTicket', function(ticketType, expiryTime)
    local source = source
    TriggerClientEvent('esx_trains:updateTicket', source, ticketType, expiryTime)
end)