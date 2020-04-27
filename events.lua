RegisterNUICallback("data_status", function(data)
    if data.type == "finished" then
        soundInfo[data.id].playing = false
        TriggerEvent("xSound:songStopPlaying", data.id)
    end
end)