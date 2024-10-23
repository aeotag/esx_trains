local trainNPCs = {}

-- NPC spawn function
local function SpawnTrainNPC(trainHandle, seat)
    if not Config.NPCs.enabled then return end
    
    local modelHash = GetHashKey(Config.NPCs.models[math.random(#Config.NPCs.models)])
    
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Wait(0)
    end
    
    local npc = CreatePed(4, modelHash, 0.0, 0.0, 0.0, 0.0, true, false)
    SetPedIntoVehicle(npc, trainHandle, seat)
    SetBlockingOfNonTemporaryEvents(npc, true)
    SetEntityInvincible(npc, true)
    
    SetModelAsNoLongerNeeded(modelHash)
    return npc
end

-- Manage NPCs for a train
local function ManageTrainNPCs(trainHandle)
    if not trainNPCs[trainHandle] then
        trainNPCs[trainHandle] = {}
        
        local seatCount = GetVehicleModelNumberOfSeats(GetEntityModel(trainHandle))
        local npcCount = math.random(1, Config.NPCs.maxPerTrain)
        
        for i = 1, npcCount do
            local seat = math.random(-1, seatCount - 2) -- -1 is driver seat
            if not trainNPCs[trainHandle][seat] then
                local npc = SpawnTrainNPC(trainHandle, seat)
                if npc then
                    trainNPCs[trainHandle][seat] = npc
                end
            end
        end
    end
end

-- Clean up NPCs
local function CleanupTrainNPCs(trainHandle)
    if trainNPCs[trainHandle] then
        for seat, npc in pairs(trainNPCs[trainHandle]) do
            if DoesEntityExist(npc) then
                DeleteEntity(npc)
            end
        end
        trainNPCs[trainHandle] = nil
    end
end

-- NPC management thread
Citizen.CreateThread(function()
    while Config.NPCs.enabled do
        Wait(1000)
        
        for _, trainData in ipairs(activeTrains) do
            if DoesEntityExist(trainData.handle) then
                ManageTrainNPCs(trainData.handle)
            end
        end
    end
end)

-- Cleanup event handler
AddEventHandler('esx_trains:deleteTrain', function(trainHandle)
    CleanupTrainNPCs(trainHandle)
end)