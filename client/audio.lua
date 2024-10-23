local currentAnnouncement = nil
local lastAnnouncementTime = 0

-- Load and cache audio files
local function LoadAudioFile(audioPath)
    RequestScriptAudioBank(audioPath, false)
end

-- Play announcement at coordinates
local function PlayAnnouncementAt(audioFile, coords)
    if not Config.Audio.enabled then return end
    
    local currentTime = GetGameTimer()
    if currentTime - lastAnnouncementTime < 5000 then return end
    
    if currentAnnouncement then
        StopSound(currentAnnouncement)
    end
    
    local announcementId = GetSoundId()
    PlaySoundFromCoord(announcementId, audioFile, coords.x, coords.y, coords.z, nil, false, Config.Audio.announcementDistance, false)
    currentAnnouncement = announcementId
    lastAnnouncementTime = currentTime
end

-- Event handler for playing announcements
RegisterNetEvent('esx_trains:playAnnouncement')
AddEventHandler('esx_trains:playAnnouncement', function(announcementType, coords)
    if Config.Audio.announcements[announcementType] then
        PlayAnnouncementAt(Config.Audio.announcements[announcementType], coords or GetEntityCoords(PlayerPedId()))
    end
end)

-- Initialize audio system
Citizen.CreateThread(function()
    if Config.Audio.enabled then
        for _, audioFile in pairs(Config.Audio.announcements) do
            LoadAudioFile(audioFile)
        end
    end
end)