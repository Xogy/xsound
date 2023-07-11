globalOptionsCache = {}
isPlayerCloseToMusic = false
disableMusic = false

function getDefaultInfo()
    return {
        volume = 1.0,
        url = "",
        id = "",
        position = nil,
        distance = 10,
        playing = false,
        paused = false,
        loop = false,
        isDynamic = false,
        timeStamp = 0,
        maxDuration = 0,
        destroyOnFinish = true,
    }
end

function UpdatePlayerPositionInNUI()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)

    SendNUIMessage({
        status = "position",
        x = pos.x,
        y = pos.y,
        z = pos.z
    })
end

function CheckForCloseMusic()
    local ped = PlayerPedId()
    local playerPos = GetEntityCoords(ped)
    isPlayerCloseToMusic = false
    for k, v in pairs(soundInfo) do
        if v.position ~= nil and v.isDynamic then
            if #(v.position - playerPos) < v.distance + config.distanceBeforeUpdatingPos then
                isPlayerCloseToMusic = true
                break
            end
        end
    end
end

-- updating position on html side so we can count how much volume the sound needs.
CreateThread(function()
    local refresh = config.RefreshTime
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local lastPos = pos
    local changedPosition = false
    while true do
        Wait(refresh)
        if not disableMusic and isPlayerCloseToMusic then
            ped = PlayerPedId()
            pos = GetEntityCoords(ped)

            -- we will update position only when player have moved
            if #(lastPos - pos) >= 0.1 then
                lastPos = pos
                UpdatePlayerPositionInNUI()
            end

            if changedPosition then
                UpdatePlayerPositionInNUI()
                SendNUIMessage({ status = "unmuteAll" })
            end
            changedPosition = false
        else
            if not changedPosition then
                changedPosition = true
                SendNUIMessage({ status = "position", x = -900000, y = -900000, z = -900000 })
                SendNUIMessage({ status = "muteAll" })
            end
            Wait(1000)
        end
    end
end)

-- checking if player is close to sound so we can switch bool value to true.
CreateThread(function()
    while true do
        Wait(500)
        CheckForCloseMusic()
    end
end)

-- updating timeStamp
CreateThread(function()
    Wait(1100)

    while true do
        Wait(1000)
        for k, v in pairs(soundInfo) do
            if v.playing or v.wasSilented then
                if getInfo(v.id).timeStamp ~= nil and getInfo(v.id).maxDuration ~= nil then
                    if getInfo(v.id).timeStamp < getInfo(v.id).maxDuration then
                        getInfo(v.id).timeStamp = getInfo(v.id).timeStamp + 1
                    end
                end
            end
        end
    end
end)

function PlayMusicFromCache(data)
    local musicCache = soundInfo[data.id]
    if musicCache then
        musicCache.SkipEvents = true
        musicCache.SkipTimeStamp = true

        PlayUrlPosSilent(data.id, data.url, data.volume, data.position, data.loop)
        onPlayStartSilent(data.id, function()
            if getInfo(data.id).maxDuration then
                setTimeStamp(data.id, data.timeStamp or 0)
            end
            Distance(data.id, data.distance)
        end)
    end
end

-- If player is far away from music we will just delete it.
CreateThread(function()
    local ped = PlayerPedId()
    local playerPos = GetEntityCoords(ped)
    local destroyedMusicList = {}
    while true do
        Wait(500)
        ped = PlayerPedId()
        playerPos = GetEntityCoords(ped)
        for k, v in pairs(soundInfo) do
            if v.position ~= nil and v.isDynamic then
                if #(v.position - playerPos) < (v.distance + config.distanceBeforeUpdatingPos) then
                    if destroyedMusicList[v.id] then
                        destroyedMusicList[v.id] = nil
                        v.wasSilented = true
                        PlayMusicFromCache(v)
                    end
                else
                    if not destroyedMusicList[v.id] then
                        destroyedMusicList[v.id] = true
                        v.wasSilented = false
                        DestroySilent(v.id)
                    end
                end
            end
        end
    end
end)