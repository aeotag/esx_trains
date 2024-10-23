local ESX = exports['es_extended']:getSharedObject()
local PlayerTickets = {}

-- Ticket types and their duration in minutes
local TicketTypes = {
    single = 60,
    day = 1440,
    week = 10080
}

-- Buy a ticket
RegisterNetEvent('esx_trains:buyTicket')
AddEventHandler('esx_trains:buyTicket', function(ticketType)
    local price = Config.TicketSystem.prices[ticketType]
    
    ESX.TriggerServerCallback('esx_trains:canBuyTicket', function(canBuy)
        if canBuy then
            local expiryTime = os.time() + (TicketTypes[ticketType] * 60)
            PlayerTickets[ticketType] = expiryTime
            
            ESX.ShowNotification('You bought a ' .. ticketType .. ' ticket')
            TriggerServerEvent('esx_trains:syncTicket', ticketType, expiryTime)
        else
            ESX.ShowNotification('You cannot afford this ticket')
        end
    end, ticketType)
end)

-- Check if player has valid ticket
local function HasValidTicket()
    local currentTime = os.time()
    
    for ticketType, expiryTime in pairs(PlayerTickets) do
        if currentTime < expiryTime then
            return true
        end
    end
    
    return false
end

-- Ticket inspection system
Citizen.CreateThread(function()
    while Config.TicketSystem.enabled do
        Wait(Config.TicketSystem.checkInterval)
        
        local playerPed = PlayerPedId()
        if IsPedInAnyTrain(playerPed) then
            if not HasValidTicket() then
                -- Play ticket check announcement
                if Config.Audio.enabled then
                    TriggerEvent('esx_trains:playAnnouncement', 'ticket_check')
                end
                
                -- Notify police and fine player
                if Config.TicketSystem.policeNotification then
                    TriggerServerEvent('esx_trains:notifyPolice', 'ticket_violation')
                end
                
                -- Fine the player
                TriggerServerEvent('esx_trains:issueFine', Config.TicketSystem.fineAmount)
            end
        end
    end
end)