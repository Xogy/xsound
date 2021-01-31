function Distance(name_, distance_)
    SendNUIMessage({
        status = "distance",
        name = name_,
        distance = distance_,
    })
    soundInfo[name_].distance = distance_
end

exports('Distance', Distance)

function Position(name_, pos)
    SendNUIMessage({
        status = "soundPosition",
        name = name_,
        x = pos.x,
        y = pos.y,
        z = pos.z,
    })
    soundInfo[name_].position = pos
    soundInfo[name_].id = name_
end

exports('Position', Position)

function Destroy(name_)
    SendNUIMessage({
        status = "delete",
        name = name_
    })
    soundInfo[name_] = nil

    if globalOptionsCache[name_] ~= nil and globalOptionsCache[name_].onPlayEnd ~= nil then
        globalOptionsCache[name_].onPlayEnd(getInfo(name_))
    end

    globalOptionsCache[name_] = nil
end

exports('Destroy', Destroy)

function Resume(name_)
    SendNUIMessage({
        status = "resume",
        name = name_
    })
    soundInfo[name_].playing = true
    soundInfo[name_].paused = false

    if globalOptionsCache[name_] ~= nil and globalOptionsCache[name_].onPlayResume ~= nil then
        globalOptionsCache[name_].onPlayResume(getInfo(name_))
    end
end

exports('Resume', Resume)

function Pause(name_)
    SendNUIMessage({
        status = "pause",
        name = name_
    })
    soundInfo[name_].playing = false
    soundInfo[name_].paused = true

    if globalOptionsCache[name_] ~= nil and globalOptionsCache[name_].onPlayPause ~= nil then
        globalOptionsCache[name_].onPlayPause(getInfo(name_))
    end
end

exports('Pause', Pause)

function setVolume(name_, vol)
    SendNUIMessage({
        status = "volume",
        volume = vol,
        name = name_,
    })
    soundInfo[name_].volume = vol
end

exports('setVolume', setVolume)

function setVolumeMax(name_, vol)
    SendNUIMessage({
        status = "max_volume",
        volume = vol,
        name = name_,
    })
    soundInfo[name_].volume = vol
end

exports('setVolumeMax', setVolumeMax)

function setTimeStamp(name_, timestamp)
    getInfo(name_).timeStamp = timestamp
    SendNUIMessage({
        name = name_,
        status = "timestamp",
        timestamp = timestamp,
    })
end

exports('setTimeStamp', setTimeStamp)

function destroyOnFinish(id, bool)
    soundInfo[id].destroyOnFinish = bool
end

exports('destroyOnFinish', destroyOnFinish)

function setSoundLoop(name, value)
    SendNUIMessage({
        status = "loop",
        name = name,
        loop = value,
    })
    soundInfo[name].loop = value
end

exports('setSoundLoop', setSoundLoop)

function repeatSound(name)
    if soundExists(name) then
        SendNUIMessage({
            status = "repeat",
            name = name,
        })
    end
end

exports('repeatSound', repeatSound)

function setSoundDynamic(name, bool)
    if soundExists(name) then
        soundInfo[name].isDynamic = bool
        SendNUIMessage({
            status = "changedynamic",
            name = name,
            bool = bool,
        })
    end
end

exports('setSoundDynamic', setSoundDynamic)

function setSoundURL(name, url)
    if soundExists(name) then
        soundInfo[name].url = url
        SendNUIMessage({
            status = "changeurl",
            name = name,
            url = url,
        })
    end
end

exports('setSoundURL', setSoundURL)