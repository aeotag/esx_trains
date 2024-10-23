local ESX = exports['es_extended']:getSharedObject()
local activeTrains = {}

-- Function to create a train
local function CreateTrain(trainConfig)
    local trainHash = GetHashKey(trainConfig.model)
    
    RequestModel(trainHash)
    while not HasModelLoaded(trainHash) do
        Wait(0)
    end
    
    -- Create the train
    local train = CreateMissionTrain(24, 
        trainConfig.startPosition.x, 
        trainConfig.startPosition.y, 
        trainConfig.startPosition.z, 
        trainConfig.isLoop
    )
    
    -- Set train speed
    SetTrainSpeed(train, trainConfig.speed)
    SetTrainCruiseSpeed(train, trainConfig.speed)
    
    -- Add to active trains
    table.insert(activeTrains, {
        handle = train,
        config = trainConfig
    })
    
    SetModelAsNoLongerNeeded(trainHash)
    return train
end

-- Function to manage trains
local function ManageTrains()
    while true do
        Wait(1000)
        
        -- Check each train
        for i, trainData in ipairs(activeTrains) do
            if not DoesEntityExist(trainData.handle) then
                -- Recreate train if it doesn't exist
                trainData.handle = CreateTrain(trainData.config)
            else
                -- Ensure train maintains speed
                SetTrainSpeed(trainData.handle, trainData.config.speed)
                SetTrainCruiseSpeed(trainData.handle, trainData.config.speed)
            end
        end
    end
end

-- Initialize trains
Citizen.CreateThread(function()
    while true do
        Wait(0)
        
        -- Initial spawn of all configured trains
        for _, trainConfig in ipairs(Config.Trains) do
            CreateTrain(trainConfig)
        end
        
        -- Start train management
        ManageTrains()
    end
end)

-- Event handler for train deletion
RegisterNetEvent('esx_trains:deleteTrain')
AddEventHandler('esx_trains:deleteTrain', function(trainIndex)
    if activeTrains[trainIndex] then
        if DoesEntityExist(activeTrains[trainIndex].handle) then
            DeleteMissionTrain(activeTrains[trainIndex].handle)
        end
        table.remove(activeTrains, trainIndex)
    end
end)

-- Debug command to spawn a specific train
RegisterCommand('spawntrain', function(source, args)
    if args[1] then
        local trainConfig = {
            model = args[1],
            speed = tonumber(args[2]) or 15.0,
            startPosition = {
                x = GetEntityCoords(PlayerPedId()).x,
                y = GetEntityCoords(PlayerPedId()).y,
                z = GetEntityCoords(PlayerPedId()).z
            },
            isLoop = true
        }
        CreateTrain(trainConfig)
    end
end, false)