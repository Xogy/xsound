function fadeIn(name, time, volume_)
    if soundExists(name) then
        volumeType(name, 0)

        local addVolume = (volume_ / time) * 100
        local called = 0
        local volume = volume_

        while true do
            volume = volume - addVolume
            if volume < 0 then volume = 0 end
            if volume == 0 then break end
            called = called + 1
        end

        volume = getVolume(name)
        while true do
            Citizen.Wait(time / called)
            volume = volume + addVolume
            if volume > volume_ then
                volume = volume_
                volumeType(name, volume)
                break
            end
            volumeType(name, volume)
        end
    end
end

exports('fadeIn', fadeIn)

function fadeOut(name, time)
    if soundExists(name) then
        local volume = getVolume(name)

        local addVolume = (volume / time) * 100
        local called = 0

        while true do
            volume = volume - addVolume
            if volume < 0 then volume = 0 end
            if volume == 0 then break end
            called = called + 1
        end

        volume = getVolume(name)
        while true do
            Citizen.Wait(time / called)
            volume = volume - addVolume
            if volume < 0 then
                volume = 0
                volumeType(name, volume)
                break
            end
            volumeType(name, volume)
        end
    end
end

exports('fadeOut', fadeOut)

function fadeVolume(name, time, volume_)
    if soundExists(name) then
        local fadeId = math.random(99999)
        soundInfo[name].fadeId = fadeId
        local initVol = soundInfo[name].volume 
        local toFade = volume_ - initVol 
        local repeats = time / 25
        local toChange = toFade / repeats

        for i = 1, repeats do
            Citizen.Wait(25)
            if soundInfo[name].fadeId ~= fadeId then
                return
            end
            volumeType(name, initVol + (toChange * i))
        end
    end
end

exports('fadeVolume', fadeVolume)

function volumeType(name, volume)
    if isDynamic(name) then
        setVolumeMax(name,volume)
        setVolume(name,volume)
    else
        setVolume(name,volume)
    end
end