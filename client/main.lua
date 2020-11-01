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


---- a simple optimization, no one is playing a music 24/7 in the server, so 0.3ms it too much (in my opinion), in this way the script will go to 0.1 when there is no music playing in the server
Citizen.CreateThread(function()
    local refresh = config.RefreshTime
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    while true do
        Citizen.Wait(refresh)
        for k, v in pairs(soundInfo) do
			if v.playing then
				ped = PlayerPedId()
				pos = GetEntityCoords(ped)
				SendNUIMessage({
					status = "position",
					x = pos.x,
					y = pos.y,
					z = pos.z
				})
				return
			end
		end
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
