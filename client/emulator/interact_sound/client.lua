if config.interact_sound_enable then

    RegisterNetEvent('InteractSound_CL:PlayOnOne')
    AddEventHandler('InteractSound_CL:PlayOnOne', function(soundFile, soundVolume)
        PlayUrl("./sounds/" .. soundFile, "./sounds/" .. soundFile .. "." .. config.interact_sound_file, soundVolume)
    end)

    RegisterNetEvent('InteractSound_CL:PlayOnAll')
    AddEventHandler('InteractSound_CL:PlayOnAll', function(soundFile, soundVolume)
        PlayUrl("./sounds/" .. soundFile, "./sounds/" .. soundFile .. "." .. config.interact_sound_file, soundVolume)
    end)

    RegisterNetEvent('InteractSound_CL:PlayWithinDistance')
    AddEventHandler('InteractSound_CL:PlayWithinDistance', function(playerNetId, maxDistance, soundFile, soundVolume)
        if GetPlayerFromServerId(playerNetId) ~= -1 then
            local eCoords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(playerNetId)))
            PlayUrlPos("./sounds/" .. soundFile, "./sounds/" .. soundFile .. "." .. config.interact_sound_file, soundVolume, eCoords)
            Distance("./sounds/" .. soundFile, maxDistance)
        end
    end)

end
