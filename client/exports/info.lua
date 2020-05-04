soundInfo = {}

defaultInfo = {
    volume = 1.0,
    url = "",
    id = "",
    position = nil,
    distance = 0,
    playing = false,
    paused = false,
    loop = false,
}

function getLink(name_)
    return soundInfo[name_].url
end

exports('getLink', getLink)

function getPosition(name_)
    return soundInfo[name_].position
end

exports('getPosition', getPosition)

function isLooped(name_)
    return soundInfo[name_].loop
end

exports('isLooped', isLooped)

function getInfo(name_)
    return soundInfo[name_]
end

exports('getInfo', getInfo)

function soundExists(name_)
    if soundInfo[name_] == nil then
        return false
    end
    return true
end

exports('soundExists', soundExists)

function isPlaying(name_)
    return soundInfo[name_].playing
end

exports('isPlaying', isPlaying)

function isPaused(name_)
    return soundInfo[name_].paused
end

exports('isPaused', isPaused)

function getDistance(name_)
    return soundInfo[name_].distance
end

exports('getDistance', getDistance)

function getVolume(name_)
    return soundInfo[name_].volume
end

exports('getVolume', getVolume)