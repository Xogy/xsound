globalOptionsCache = {}
isPlayerCloseToMusic = false
disableMusic = false

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
        destroyOnFinish = true,
    }
end

-- updating position on html side so we can count how much volume the sound needs.
CreateThread(function()
    local refresh = config.RefreshTime
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local changedPosition = false
    while true do
        Wait(refresh)
        if not disableMusic and isPlayerCloseToMusic then
            ped = PlayerPedId()
            pos = GetEntityCoords(ped)
            SendNUIMessage({
                status = "position",
                x = pos.x,
                y = pos.y,
                z = pos.z
            })

            if changedPosition then
                SendNUIMessage({ status = "unmuteAll" })
            end
            changedPosition = false
        else
            if not changedPosition then
                changedPosition = true
                SendNUIMessage({ status = "position", x = -900000, y = -900000, z = -900000 })
            end
			
			SendNUIMessage({ status = "muteAll" })			
            Wait(1000)
        end
    end
end)

-- checking if player is close to sound so we can switch bool value to true.
CreateThread(function()
    local ped = PlayerPedId()
    local playerPos = GetEntityCoords(ped)
    while true do
        Wait(500)
        ped = PlayerPedId()
        playerPos = GetEntityCoords(ped)
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
end)

-- updating timeStamp
CreateThread(function()
    Wait(1100)
    while true do
        Wait(1000)
        for k, v in pairs(soundInfo) do
            if v.playing then
                if getInfo(v.id).timeStamp ~= nil and getInfo(v.id).maxDuration ~= nil then
                    if getInfo(v.id).timeStamp < getInfo(v.id).maxDuration then
                        getInfo(v.id).timeStamp = getInfo(v.id).timeStamp + 1
                    end
                end
            end
        end
    end
end)