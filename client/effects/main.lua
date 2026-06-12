function fadeIn(name, time, volume_)
    if not soundExists(name) then return end
    if type(time) ~= "number" or type(volume_) ~= "number" then return end
    if time <= 0 or volume_ <= 0 then return end

    local steps = math.ceil(time / 100)
    if steps < 1 then steps = 1 end
    local stepVolume = volume_ / steps
    local wait = time / steps

    volumeType(name, 0)

    local volume = 0
    for _ = 1, steps do
        Citizen.Wait(wait)
        if not soundExists(name) then return end
        volume = volume + stepVolume
        if volume > volume_ then volume = volume_ end
        volumeType(name, volume)
    end
end

exports('fadeIn', fadeIn)

function fadeOut(name, time)
    if not soundExists(name) then return end
    if type(time) ~= "number" or time <= 0 then return end

    local volume = getVolume(name)
    if type(volume) ~= "number" or volume <= 0 then
        volumeType(name, 0)
        return
    end

    local steps = math.ceil(time / 100)
    if steps < 1 then steps = 1 end
    local stepVolume = volume / steps
    local wait = time / steps

    for _ = 1, steps do
        Citizen.Wait(wait)
        if not soundExists(name) then return end
        volume = volume - stepVolume
        if volume < 0 then volume = 0 end
        volumeType(name, volume)
    end
end

exports('fadeOut', fadeOut)

function volumeType(name, volume)
    if isDynamic(name) then
        setVolumeMax(name, volume)
        setVolume(name, volume)
    else
        setVolume(name, volume)
    end
end
