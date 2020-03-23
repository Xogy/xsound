soundInfo = {}

defaultInfo = {
    volume = 1.0,
    url = "",
    id = "",
    position = nil,
    distance = 0,
    playing = false,
}

Citizen.CreateThread(function()
    Citizen.Wait(1000)
    --[[
    exports.xPlayer:Play("name",1)
    exports.xPlayer:PlayPos("name",1,pos)

    exports.xPlayer:PlayUrl("name","url",1)
    exports.xPlayer:PlayUrlPos('test',"http://relisoft.cz/assets/brainleft.mp3",1,pos)

    exports.xPlayer:Pause("name")
    exports.xPlayer:Stop("name")
    exports.xPlayer:Resume("name")
    exports.xPlayer:Distance("name",100)
    exports.xPlayer:Position("name",pos)
    --]]
    local refresh = config.RefreshTime
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    while true do
        Citizen.Wait(refresh)
        ped = PlayerPedId()
        pos = GetEntityCoords(ped)
        SendNUIMessage({
            status = "position",
            x = pos.x,
            y = pos.y,
            z = pos.z
        })
    end
end)

function distance(name_, distance_)
    SendNUIMessage({
        status = "distance",
        name = name_,
        distance = distance_,
    })
end

exports('Distance', distance)

function playurl(name_, url_, volume_)
    SendNUIMessage({
        status = "url",
        name = name_,
        url = url_,
        x = 0,
        y = 0,
        z = 0,
        dynamic = false,
        volume = volume_,
    })

    if soundInfo[name_] == nil then soundInfo[name_] = defaultInfo end

    soundInfo[name_].volume = volume_
    soundInfo[name_].url = url_
    soundInfo[name_].id = name_
    soundInfo[name_].playing = true
end

exports('PlayUrl', playurl)

function playurlpos(name_, url_, volume_, pos)
    SendNUIMessage({
        status = "url",
        name = name_,
        url = url_,
        x = pos.x,
        y = pos.y,
        z = pos.z,
        dynamic = true,
        volume = volume_,
    })
    if soundInfo[name_] == nil then soundInfo[name_] = defaultInfo end

    soundInfo[name_].volume = volume_
    soundInfo[name_].url = url_
    soundInfo[name_].position = pos
    soundInfo[name_].id = name_
    soundInfo[name_].playing = true
end

exports('PlayUrlPos', playurlpos)

function playpos(name_, volume_, pos)
    SendNUIMessage({
        status = "play",
        name = name_,
        x = pos.x,
        y = pos.y,
        z = pos.z,
        dynamic = true,
        volume = volume_,
    })
    if soundInfo[name_] == nil then soundInfo[name_] = defaultInfo end

    soundInfo[name_].volume = volume_
    soundInfo[name_].position = pos
    soundInfo[name_].id = name_
    soundInfo[name_].playing = true
end

exports('PlayPos', playpos)

function play(name_, volume_)
    SendNUIMessage({
        status = "play",
        name = name_,
        x = 0,
        y = 0,
        z = 0,
        dynamic = false,
        volume = volume_,
    })
    if soundInfo[name_] == nil then soundInfo[name_] = defaultInfo end

    soundInfo[name_].volume = volume_
    soundInfo[name_].id = name_
    soundInfo[name_].playing = true
end

exports('Play', play)

function position(name_, pos)
    SendNUIMessage({
        status = "soundPosition",
        name = name_,
        x = pos.x,
        y = pos.y,
        z = pos.z,
    })

    if soundInfo[name_] == nil then soundInfo[name_] = defaultInfo end

    soundInfo[name_].position = pos
    soundInfo[name_].id = name_
end

exports('Position', position)

function stop(name_)
    SendNUIMessage({
        status = "delete",
        name = name_
    })
    soundInfo[name_] = nil
end

exports('Stop', stop)

function resume(name_)
    SendNUIMessage({
        status = "resume",
        name = name_
    })
    if soundInfo[name_] == nil then soundInfo[name_] = defaultInfo end
    soundInfo[name_].playing = true
end

exports('Resume', resume)

function pause(name_)
    SendNUIMessage({
        status = "pause",
        name = name_
    })
    if soundInfo[name_] == nil then soundInfo[name_] = defaultInfo end
    soundInfo[name_].playing = false
end

exports('Pause', pause)

function volume(name_, vol)
    SendNUIMessage({
        status = "volume",
        volume = vol,
        name = name_,
    })
    if soundInfo[name_] == nil then soundInfo[name_] = defaultInfo end

    soundInfo[name_].volume = vol
end

exports('setVolume', volume)

function getvolume(name_)
    return soundInfo[name_].volume
end

exports('getVolume', getvolume)

function getInfo(name_)
    return soundInfo[name_]
end

exports('getInfo', getInfo)
