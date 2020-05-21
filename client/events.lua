RegisterNUICallback("data_status", function(data)
    if data.type == "finished" then
        soundInfo[data.id].playing = false
        TriggerEvent("xSound:songStopPlaying", data.id)
    end
end)

RegisterNetEvent("xsound:stateSound")
AddEventHandler("xsound:stateSound", function(state, data)
    local soundId = data.soundId

    if state == "play" then
        PlayUrl(soundId, data.url, data.volume, data.loop or false)
    end

    if state == "playpos" then
        PlayUrlPos(soundId, data.url, data.volume, data.position, data.loop or false)
    end

    if state == "position" then
        if soundExists(soundId) then
            Position(soundId,data.position)
        end
    end

    if state == "distance" then
        if soundExists(soundId) then
            Distance(soundId,data.distance)
        end
    end

    if state == "destroy" then
        if soundExists(soundId) then
            Destroy(soundId)
        end
    end

    if state == "pause" then
        if soundExists(soundId) then
            Pause(soundId)
        end
    end

    if state == "resume" then
        if soundExists(soundId) then
            Resume(soundId)
        end
    end

    if state == "volume" then
        if soundExists(soundId) then
            if isDynamic(soundId) then
                setVolumeMax(soundId, data.volume)
            else
                setVolume(soundId, data.volume)
            end
        end
    end
end)
