soundInfo = {}

function soundExists(name_)
    if soundInfo[name_] == nil then
        return false
    end
    return true
end

exports('soundExists', soundExists)

function getLink(name_)
    if not soundExists(name_) then return nil end
    return soundInfo[name_].url
end

exports('getLink', getLink)

function getPosition(name_)
    if not soundExists(name_) then return nil end
    return soundInfo[name_].position
end

exports('getPosition', getPosition)

function isLooped(name_)
    if not soundExists(name_) then return false end
    return soundInfo[name_].loop
end

exports('isLooped', isLooped)

function getInfo(name_)
    return soundInfo[name_]
end

exports('getInfo', getInfo)

function isPlaying(name_)
    if not soundExists(name_) then return false end
    return soundInfo[name_].playing
end

exports('isPlaying', isPlaying)

function isPaused(name_)
    if not soundExists(name_) then return false end
    return soundInfo[name_].paused
end

exports('isPaused', isPaused)

function getDistance(name_)
    if not soundExists(name_) then return nil end
    return soundInfo[name_].distance
end

exports('getDistance', getDistance)

function getVolume(name_)
    if not soundExists(name_) then return nil end
    return soundInfo[name_].volume
end

exports('getVolume', getVolume)

function isDynamic(name_)
    if not soundExists(name_) then return false end
    return soundInfo[name_].isDynamic
end

exports('isDynamic', isDynamic)

function getTimeStamp(name_)
    if not soundExists(name_) then return -1 end
    return soundInfo[name_].timeStamp or -1
end

exports('getTimeStamp', getTimeStamp)

function getMaxDuration(name_)
    if not soundExists(name_) then return -1 end
    return soundInfo[name_].maxDuration or -1
end

exports('getMaxDuration', getMaxDuration)

function isPlayerInStreamerMode()
    return disableMusic
end

exports('isPlayerInStreamerMode', isPlayerInStreamerMode)

function getAllAudioInfo()
    return soundInfo
end

exports('getAllAudioInfo', getAllAudioInfo)

function isPlayerCloseToAnySound()
    return isPlayerCloseToMusic
end

exports('isPlayerCloseToAnySound', isPlayerCloseToAnySound)
