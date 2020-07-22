globalOptionsCache = {}

function getDefaultInfo()
    return {
        volume = 1.0,
        url = "",
        id = "",
        position = nil,
        distance = 0,
        playing = false,
        paused = false,
        loop = false,
        isDynamic = false,
        timeStamp = 0,
        maxDuration = 0,
    }
end

Citizen.CreateThread(function()
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

Citizen.CreateThread(function()
    Citizen.Wait(1100)
    while true do
        for k, v in pairs(soundInfo) do
            if v.playing then
                if getInfo(v.id).timeStamp ~= nil and getInfo(v.id).maxDuration ~= nil then
                    if getInfo(v.id).timeStamp < getInfo(v.id).maxDuration then
                        getInfo(v.id).timeStamp = getInfo(v.id).timeStamp + 1
                    end
                end
            end
        end
        Citizen.Wait(1000)
    end
end)