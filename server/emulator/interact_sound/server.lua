RegisterServerEvent('InteractSound_SV:PlayOnOne')
AddEventHandler('InteractSound_SV:PlayOnOne', function(clientNetId, soundFile, soundVolume)
    local src <const> = source
    local ok, d = Security.check(src, 'single', { file = soundFile, volume = soundVolume })
    if not ok then return end
    TriggerClientEvent('InteractSound_CL:PlayOnOne', clientNetId, d.file, d.volume)
end)

RegisterServerEvent('InteractSound_SV:PlayOnSource')
AddEventHandler('InteractSound_SV:PlayOnSource', function(soundFile, soundVolume)
    local src <const> = source
    local ok, d = Security.check(src, 'single', { file = soundFile, volume = soundVolume })
    if not ok then return end
    TriggerClientEvent('InteractSound_CL:PlayOnOne', src, d.file, d.volume)
end)

RegisterServerEvent('InteractSound_SV:PlayOnAll')
AddEventHandler('InteractSound_SV:PlayOnAll', function(soundFile, soundVolume)
    local src <const> = source
    local ok, d = Security.check(src, 'broadcast', { file = soundFile, volume = soundVolume })
    if not ok then return end
    TriggerClientEvent('InteractSound_CL:PlayOnAll', -1, d.file, d.volume)
end)

RegisterServerEvent('InteractSound_SV:PlayWithinDistance')
AddEventHandler('InteractSound_SV:PlayWithinDistance', function(maxDistance, soundFile, soundVolume)
    local src <const> = source
    local ok, d = Security.check(src, 'broadcast', { file = soundFile, volume = soundVolume, distance = maxDistance })
    if not ok then return end
    TriggerClientEvent('InteractSound_CL:PlayWithinDistance', -1, src, d.distance, d.file, d.volume)
end)
