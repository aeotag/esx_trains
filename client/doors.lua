local ESX = exports['es_extended']:getSharedObject()
local doorState = {}

-- Door control functions
local function OpenTrainDoors(trainHandle)
    if not DoesEntityExist(trainHandle) then return end
    SetVehicleDoorOpen(trainHandle, 0, false, false)    -- Left door
    SetVehicleDoorOpen(trainHandle, 1, false, false)    -- Right door
    doorState[trainHandle] = 'open'
end

local function CloseTrainDoors(trainHandle)
    if not DoesEntityExist(trainHandle) then return end
    SetVehicleDoorShut(trainHandle, 0, false)    -- Left door
    SetVehicleDoorShut(trainHandle, 1, false)    -- Right door
    doorState[trainHandle] = 'closed'
end

-- Check if train is at station
local function IsTrainAtStation(trainCoords)
    for _, station in ipairs(Stations.List) do
        local distance = #(trainCoords - vector3(station.coords.x, station.coords.y, station.coords.z))
        if distance < 10.0 then -- Adjust this value based on station size
            return true
        end
    end
    return false
end

-- Door management thread
Citizen.CreateThread(function()
    while true do
        Wait(1000)
        
        for _, trainData in ipairs(activeTrains) do
            if DoesEntityExist(trainData.handle) then
                local trainSpeed = GetEntitySpeed(trainData.handle)
                local trainCoords = GetEntityCoords(trainData.handle)
                
                -- Close doors when moving
                if trainSpeed > 0.1 then -- Small threshold to account for minor movements
                    if doorState[trainData.handle] ~= 'closed' then
                        CloseTrainDoors(trainData.handle)
                        -- Play door closing sound if available
                        if Config.Audio.enabled then
                            TriggerEvent('esx_trains:playAnnouncement', 'doors_closing')
                        end
                    end
                -- Open doors at stations when stopped
                elseif IsTrainAtStation(trainCoords) then
                    if doorState[trainData.handle] ~= 'open' then
                        OpenTrainDoors(trainData.handle)
                        -- Play door opening sound if available
                        if Config.Audio.enabled then
                            TriggerEvent('esx_trains:playAnnouncement', 'doors_opening')
                        end
                    end
                end
            end
        end
    end
end)

-- Cleanup
AddEventHandler('esx_trains:deleteTrain', function(trainHandle)
    doorState[trainHandle] = nil
end)