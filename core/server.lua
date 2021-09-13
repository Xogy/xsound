
musictable = {}

RegisterNetEvent("myevent:soundStatus")
AddEventHandler("myevent:soundStatus", function(type, musicid, data)
    if type == 'play' then
    musictable[musicid] = {}
    musictable[musicid] = data
    print("playing")
    TriggerClientEvent("myevent:soundStatus", -1, type, musictable)
    end
    if type == 'position' then
    musictable[musicid] = data
    TriggerClientEvent("myevent:soundStatus", -1, type, musictable)
    end
    if type == 'remove' then
    musictable[musicid] = nil
    print("remove")
    TriggerClientEvent("myevent:soundStatus", -1, type, musictable)
    end
    if type == 'volume' then
    print("volume")
    musictable[musicid] = data
    TriggerClientEvent("myevent:soundStatus", -1, type, musictable)
    end
end)