-- i recommend to NOT change the command name. it will make easier for people to use this command
-- when ever is this library.. so please keep this command name on "streamermode" command
local streamermode = false
local cachedVolume = {}
local function streamerMode()
    streamerMode = not streamerMode
    TriggerEvent('chat:addMessage', { args = { "^1[xSound]", streamerMode and config.Messages["streamer_on"] or config.Messages["streamer_off"] } })

    if not streamerMode then
        for id, volume in pairs(cachedVolume) do
            if soundExists(id) then
                setVolume(id, volume)
            end
        end

        cachedVolume = {}
        return
    end

    while streamerMode do
        for _, data in pairs(soundInfo) do
            if data.volume ~= 0 then
                cachedVolume[data.id] = data.volume
                setVolume(data.id, 0.0)
            end
        end
        Wait(500)
    end
end
RegisterCommand('streamermode', streamerMode)