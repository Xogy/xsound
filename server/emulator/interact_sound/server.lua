local SPAM_COOLDOWN = 150
local lastTrigger = {}

local function isRateLimited(src)
    local n = tonumber(src)
    if n == nil or n <= 0 then
        return false
    end
    local now = GetGameTimer()
    local last = lastTrigger[n]
    if last and (now - last) < SPAM_COOLDOWN then
        return true
    end
    lastTrigger[n] = now
    return false
end

local function safeSoundFile(soundFile)
    if type(soundFile) ~= "string" then return nil end
    if soundFile == "" then return nil end
    if soundFile:find("%.%.") then return nil end
    if soundFile:find("[\\:]") then return nil end
    if soundFile:sub(1, 1) == "/" then return nil end
    if not soundFile:match("^[%w%-_/%.]+$") then return nil end
    return soundFile
end

RegisterServerEvent('InteractSound_SV:PlayOnOne')
AddEventHandler('InteractSound_SV:PlayOnOne', function(clientNetId, soundFile, soundVolume)
    if isRateLimited(source) then return end
    soundFile = safeSoundFile(soundFile)
    if not soundFile then return end
    TriggerClientEvent('InteractSound_CL:PlayOnOne', clientNetId, soundFile, soundVolume)
end)

RegisterServerEvent('InteractSound_SV:PlayOnSource')
AddEventHandler('InteractSound_SV:PlayOnSource', function(soundFile, soundVolume)
    if isRateLimited(source) then return end
    soundFile = safeSoundFile(soundFile)
    if not soundFile then return end
    TriggerClientEvent('InteractSound_CL:PlayOnOne', source, soundFile, soundVolume)
end)

RegisterServerEvent('InteractSound_SV:PlayOnAll')
AddEventHandler('InteractSound_SV:PlayOnAll', function(soundFile, soundVolume)
    if isRateLimited(source) then return end
    soundFile = safeSoundFile(soundFile)
    if not soundFile then return end
    TriggerClientEvent('InteractSound_CL:PlayOnAll', -1, soundFile, soundVolume)
end)

RegisterServerEvent('InteractSound_SV:PlayWithinDistance')
AddEventHandler('InteractSound_SV:PlayWithinDistance', function(maxDistance, soundFile, soundVolume)
    if isRateLimited(source) then return end
    soundFile = safeSoundFile(soundFile)
    if not soundFile then return end
    TriggerClientEvent('InteractSound_CL:PlayWithinDistance', -1, source, maxDistance, soundFile, soundVolume)
end)

AddEventHandler('playerDropped', function()
    local n = tonumber(source)
    if n then
        lastTrigger[n] = nil
    end
end)
