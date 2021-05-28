if config.interact_sound_enable then

    RegisterNetEvent('InteractSound_CL:PlayOnOne')
    AddEventHandler('InteractSound_CL:PlayOnOne', function(soundFile, soundVolume)
        math.randomseed(GetGameTimer())
        local randomnum = math.random(1,100000000000)..''..math.random(1,100000000000)..''..math.random(1,100000000000)
        PlayUrl("./sounds/" .. soundFile .. '_' .. randomnum, "./sounds/" .. soundFile .. "." .. config.interact_sound_file, soundVolume)
    end)

    RegisterNetEvent('InteractSound_CL:PlayOnAll')
    AddEventHandler('InteractSound_CL:PlayOnAll', function(soundFile, soundVolume)
        math.randomseed(GetGameTimer())
        local randomnum = math.random(1,100000000000)..''..math.random(1,100000000000)..''..math.random(1,100000000000)
        PlayUrl("./sounds/" .. soundFile .. '_' .. randomnum, "./sounds/" .. soundFile .. "." .. config.interact_sound_file, soundVolume)
    end)

    RegisterNetEvent('InteractSound_CL:PlayWithinDistance')
    AddEventHandler('InteractSound_CL:PlayWithinDistance', function(playerNetId, maxDistance, soundFile, soundVolume)
        math.randomseed(GetGameTimer())
        local randomnum = math.random(1,100000000000)..''..math.random(1,100000000000)..''..math.random(1,100000000000)
	local is_networked = NetworkIsPlayerActive(GetPlayerFromServerId(playerNetId))
        if GetPlayerFromServerId(playerNetId) ~= -1 and is_networked then
            local eCoords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(playerNetId)))
            PlayUrlPos("./sounds/" .. soundFile .. '_' .. randomnum, "./sounds/" .. soundFile .. "." .. config.interact_sound_file, soundVolume, eCoords)
            Distance("./sounds/" .. soundFile, maxDistance)
        end
    end)

end
