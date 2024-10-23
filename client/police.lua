local lastShootingAlert = 0
local lastTicketAlert = 0

-- Check for shooting in trains
Citizen.CreateThread(function()
    while Config.PoliceAlert.enabled do
        Wait(1000)
        
        local playerPed = PlayerPedId()
        if IsPedInAnyTrain(playerPed) and IsPedShooting(playerPed) then
            local currentTime = GetGameTimer()
            
            if currentTime - lastShootingAlert > Config.PoliceAlert.shootingCooldown then
                local coords = GetEntityCoords(playerPed)
                TriggerServerEvent('esx_trains:notifyPolice', 'shooting', {
                    coords = coords,
                    trainId = GetVehiclePedIsIn(playerPed, false)
                })
                lastShootingAlert = currentTime
            end
        end
    end
end)

-- Police notification handler
RegisterNetEvent('esx_trains:receivePoliceAlert')
AddEventHandler('esx_trains:receivePoliceAlert', function(alertType, data)
    if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' then
        local alertMessage = ''
        local blipSprite = 161
        
        if alertType == 'shooting' then
            alertMessage = 'Shooting reported on train ' .. data.trainId
            blipSprite = 156
        elseif alertType == 'ticket_violation' then
            alertMessage = 'Ticket violation reported on public transport'
            blipSprite = 108
        end
        
        ESX.ShowNotification(alertMessage)
        
        -- Create temporary blip
        local blip = AddBlipForCoord(data.coords.x, data.coords.y, data.coords.z)
        SetBlipSprite(blip, blipSprite)
        SetBlipColour(blip, 1)
        SetBlipAsShortRange(blip, true)
        
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(alertMessage)
        EndTextCommandSetBlipName(blip)
        
        -- Remove blip after 2 minutes
        Citizen.SetTimeout(120000, function()
            RemoveBlip(blip)
        end)
    end
end)