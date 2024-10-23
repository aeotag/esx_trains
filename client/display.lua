local ESX = exports['es_extended']:getSharedObject()
local Stations = exports['esx_trains']:getStations()

local function FormatTime(hour, minute)
    return string.format("%02d:%02d", hour, minute)
end

local function CreateStationDisplay()
    local function DrawText3D(x, y, z, text)
        local onScreen, _x, _y = World3dToScreen2d(x, y, z)
        if onScreen then
            SetTextScale(0.35, 0.35)
            SetTextFont(4)
            SetTextProportional(1)
            SetTextColour(255, 255, 255, 255)
            SetTextEntry("STRING")
            SetTextCentre(1)
            AddTextComponentString(text)
            DrawText(_x, _y)
        end
    end

    Citizen.CreateThread(function()
        while Config.Display.enabled do
            Wait(Config.Display.updateInterval)
            
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            
            for _, station in ipairs(Stations.List) do
                local distance = #(playerCoords - vector3(station.coords.x, station.coords.y, station.coords.z))
                
                if distance <= Config.Display.maxDisplayDistance then
                    local nextArrival = Stations.GetNextArrival(station.id)
                    if nextArrival then
                        local displayText = string.format("Next train: %s\nDestination: %s", 
                            FormatTime(nextArrival.hour, nextArrival.minute),
                            station.nextStations[1])
                        DrawText3D(station.coords.x, station.coords.y, station.coords.z + 1.0, displayText)
                    end
                end
            end
        end
    end)
end

-- Initialize display system
CreateStationDisplay()