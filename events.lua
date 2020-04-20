RegisterNUICallback("data_status", function(data)
    if data.type == "finished" then
        soundInfo[data.id].playing = false
    end
end)