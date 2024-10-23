local ESX = exports['es_extended']:getSharedObject()

-- Server-side train management
RegisterServerEvent('esx_trains:syncTrains')
AddEventHandler('esx_trains:syncTrains', function(trains)
    TriggerClientEvent('esx_trains:updateTrains', -1, trains)
end)

-- Admin command to delete all trains
ESX.RegisterCommand('deletealltrains', 'admin', function(xPlayer, args, showError)
    TriggerClientEvent('esx_trains:deleteAllTrains', -1)
end, false, {help = 'Delete all active trains'})