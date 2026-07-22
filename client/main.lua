globalOptionsCache = {}
isPlayerCloseToMusic = false
disableMusic = false

-- ids whose NUI player was silently deleted (out of range) and must be recreated
-- from cache on approach; Destroy() clears entries so the table cannot grow forever
destroyedMusicList = {}
-- consecutive out-of-range polls per id, for the destroy dwell below
outOfRangeTicks = {}

-- YouTube's embed JS leaks memory in CEF (issue #70), and that cannot be fixed
-- from the embedding page. Playback therefore runs in a disposable DUI browser
-- instead of the shared NUI process: the player page pings every 2s, and if the
-- pings stop (browser crashed or hung) the DUI is destroyed and recreated, then
-- active sounds are replayed from cache. Only music restarts — the main UI
-- (phone, HUD, inventory) is never affected.
GlobalSoundDui = nil
local MAX_PING = 6
local pingCount = MAX_PING
local haveCrashed = false
local DUI_URL = "nui://xsound/html/index.html"

function SendNUIMessage(data)
    if GlobalSoundDui and IsDuiAvailable(GlobalSoundDui) then
        SendDuiMessage(GlobalSoundDui, json.encode(data))
    end
end

CreateThread(function()
    GlobalSoundDui = CreateDui(DUI_URL, 1920, 1080)

    while true do
        Wait(2100)
        pingCount = pingCount - 1

        if pingCount <= 0 then
            pingCount = MAX_PING
            haveCrashed = true

            for k, v in pairs(soundInfo) do
                v.wasSilented = false
            end

            if GlobalSoundDui then
                DestroyDui(GlobalSoundDui)
                GlobalSoundDui = nil
            end

            Wait(1000)

            GlobalSoundDui = CreateDui(DUI_URL, 1920, 1080)
        end
    end
end)

RegisterNUICallback("ping", function(data, cb)
    if pingCount < MAX_PING then
        pingCount = pingCount + 1
    end

    if cb then
        cb('ok')
    end
end)

RegisterNUICallback("init", function(data, cb)
    pingCount = MAX_PING

    if haveCrashed then
        haveCrashed = false

        local playerPos = GetEntityCoords(PlayerPedId())
        for k, v in pairs(soundInfo) do
            if not isPaused(v.id) then
                if not v.isDynamic then
                    v.wasSilented = true
                    PlayMusicFromCache(v)
                elseif v.position ~= nil and not destroyedMusicList[v.id]
                    and #(v.position - playerPos) < (v.distance + config.distanceBeforeUpdatingPos) then
                    v.wasSilented = true
                    PlayMusicFromCache(v)
                end
            end
        end

        UpdatePlayerPositionInNUI()
        SendNUIMessage({ status = "unmuteAll" })
    end

    if cb then
        cb('ok')
    end
end)

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
                if v.timeStamp ~= nil and v.maxDuration ~= nil then
                    if v.timeStamp < v.maxDuration then
                        v.timeStamp = v.timeStamp + 1
                    elseif destroyedMusicList[v.id] and v.maxDuration > 0
                        and v.destroyOnFinish and not v.loop then
                        -- Finished while silenced (out of range): no NUI player exists
                        -- to report onEnd, so without this the entry lives forever and
                        -- respawns a fresh YouTube embed on every range re-entry.
                        Destroy(v.id)
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

        if data.isDynamic and data.position ~= nil then
            PlayUrlPosSilent(data.id, data.url, data.volume, data.position, data.loop)
        else
            -- non-dynamic sounds (replayed after a DUI restart) have no position
            SendNUIMessage({
                status = "url",
                name = data.id,
                url = data.url,
                x = 0,
                y = 0,
                z = 0,
                dynamic = false,
                volume = data.volume,
                loop = data.loop or false,
            })
        end
        onPlayStartSilent(data.id, function()
            if getInfo(data.id).maxDuration then
                setTimeStamp(data.id, data.timeStamp or 0)
            end
            Distance(data.id, data.distance)
        end)
    end
end

-- If player is far away from music we will just delete it.
-- Hysteresis + dwell: recreate at (distance + margin) but destroy only after the
-- sound has stayed beyond (distance + margin + hysteresis) for several consecutive
-- polls. A listener straddling the boundary must not rebuild a full YouTube embed
-- every 500ms — that create/teardown churn is the main leak amplifier in the shared
-- CEF process (issue #70). The band is inaudible: the NUI already mutes beyond
-- v.distance, well inside the recreate radius.
CreateThread(function()
    local ped = PlayerPedId()
    local playerPos = GetEntityCoords(ped)
    local hysteresis = 20.0
    local destroyDwellTicks = 4
    while true do
        Wait(500)
        ped = PlayerPedId()
        playerPos = GetEntityCoords(ped)
        for k, v in pairs(soundInfo) do
            if v.position ~= nil and v.isDynamic then
                local dist = #(v.position - playerPos)
                if dist < (v.distance + config.distanceBeforeUpdatingPos) then
                    outOfRangeTicks[v.id] = nil
                    if not isPaused(v.id) then
                        if destroyedMusicList[v.id] then
                            destroyedMusicList[v.id] = nil
                            v.wasSilented = true
                            PlayMusicFromCache(v)
                        end
                    end
                elseif dist > (v.distance + config.distanceBeforeUpdatingPos + hysteresis) then
                    if not destroyedMusicList[v.id] then
                        outOfRangeTicks[v.id] = (outOfRangeTicks[v.id] or 0) + 1
                        if outOfRangeTicks[v.id] >= destroyDwellTicks then
                            outOfRangeTicks[v.id] = nil
                            destroyedMusicList[v.id] = true
                            v.wasSilented = false
                            DestroySilent(v.id)
                        end
                    end
                else
                    -- inside the hysteresis band: hold current state
                    outOfRangeTicks[v.id] = nil
                end
            end
        end
    end
end)