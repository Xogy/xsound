xSound = exports.renzu_mp3

local markers = {}
local checkprop
local objects = {}
local localplay = {}
function ShowFloatingHelpNotification(msg, coords)
    AddTextEntry('FloatingHelpNotificationmp3', msg)
    SetFloatingHelpTextWorldPosition(1, coords+vector3(0,0,0.3))
    SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
    BeginTextCommandDisplayHelp('FloatingHelpNotificationmp3')
    EndTextCommandDisplayHelp(2, false, false, -1)
end

function DrawMarkerInput(vec,msg,name)
    ShowFloatingHelpNotification(msg,vec)
end

local syncvol = 1.0
function updateVolume(dd,maxd,k,sv,dis)
    local d_max = maxd;
    local d_now = dd;

    local vol = 0;
    local distance = (d_now / d_max)
    if (distance < 1) then
        distance = distance * 100
        local far_away = 100 - distance
        vol = (1.0 / 100) * far_away
        vol = vol * sv
        if vol < 0.05 and dis < d_max then
            vol = 0.05
        end
        xSound:setVolume(k,vol)
    else
        vol = 0
        -- mutefade
        if dis < (d_max + 3) then
            vol = 0.05
        elseif dis < (d_max + 6) then
            vol = 0.02
        elseif dis < (d_max + 8) then
            vol = 0.01
        end
        xSound:setVolume(k,vol)
    end
end

finaldistance = 0
local musicId
local play = {}
local musictable = {}
local playing = false
cache = {}
Citizen.CreateThread(function()
    Citizen.Wait(1000)
    local pos
    while true do
        local sleep = 2000
            local ped = PlayerPedId()
            local view = GetGameplayCamCoord()
            local pedloc = GetEntityCoords(ped)
            local pid = PlayerId()
            local inveh = IsPedInAnyVehicle(ped, false)
            if inveh then
                musicId = GetVehiclePedIsIn(ped, false)
            else
                musicId = GetPlayerServerId(pid)
            end
            for k,v in pairs(musictable) do
                toped = GetPlayerPed(GetPlayerFromServerId(k))
                toob = IsEntityAnObject(tonumber(k))
                toveh = IsEntityAVehicle(tonumber(NetToVeh(k)))
                if #(v.position - pedloc) < 50 then
                        if v.type == 'vehicle' then
                            sleep = 111
                            cache[k] = v.position
                            musicsource = NetToVeh(k)
                        else
                            if inveh then
                                sleep = 111
                            end
                            musicsource = toped
                            sleep = 222
                        end
                        if xSound:soundExists(k) then
                            local distance = #(pedloc - v.position)
                            debugdis = distance
                            local viewvolume = #(v.position - view)
                            local distance_max = 23
                            local cameraRotation = GetGameplayCamRot()
                            local cameraCoord = GetGameplayCamCoord()
                            local direction = RotationToDirection(cameraRotation)
                            if distance > 20 then
                                distance = distance - viewvolume
                            end
                            destination = vector3(
                            cameraCoord.x + direction.x * (10 ), 
                            cameraCoord.y + direction.y * (10 ), 
                            cameraCoord.z + direction.z * (10 )
                            )
                            local finaldistance = #(destination - v.position)
                            if finaldistance > 20 then
                                finaldistance = finaldistance
                            end
                                old_dis = finaldistance
                                old_max = distance_max
                                updateVolume(finaldistance,distance_max,k,v.volume,debugdis)
                            if xSound:isPlaying(k) and tonumber(v.owner) == tonumber(GetPlayerServerId(pid)) then
                                if v.type == 'vehicle' then
                                pos = GetEntityCoords(musicsource)
                                else
                                pos = v.position
                                end
                                v.owner = GetPlayerServerId(pid)
                                v.volume = v.volume
                                v.position = pos
                                TriggerServerEvent("myevent:soundStatus", "position", k, v)
                            else
                                Citizen.Wait(1000)
                            end
                        else
                            Citizen.Wait(1000)
                        end
                else
                    play[k] = false
                end
            end
        Citizen.Wait(sleep)
    end
end)

local open = false

RegisterCommand("playmusic", function(source, args, rawCommand)
    open = not open
    SendNUIMessage({
        open = "ui",
        status = open
    })
    SetNuiFocus(open, open)
end, false)

function RotationToDirection(rotation)
	local adjustedRotation = 
	{ 
		x = (math.pi / 180) * rotation.x, 
		y = (math.pi / 180) * rotation.y, 
		z = (math.pi / 180) * rotation.z 
	}
	local direction = 
	{
		x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)), 
		y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)), 
		z = math.sin(adjustedRotation.x)
	}
	return direction
end

RegisterCommand("gotocam", function(source, args, rawCommand)
    distance = 20
    local view = GetGameplayCamCoord()
    local invert = GetCamMatrix()
    local cameraRotation = GetGameplayCamRot()
	local cameraCoord = GetGameplayCamCoord()
	local direction = RotationToDirection(cameraRotation)
	local destination = 
	{ 
		x = cameraCoord.x + direction.x * distance, 
		y = cameraCoord.y + direction.y * distance, 
		z = GetEntityCoords(PlayerPedId()).z-0.5
	}
    SetEntityCoords(PlayerPedId(), destination.x,destination.y,destination.z, false, false, false, true)
end, false)

local tryingtoplay = nil

LoadModel = function(model)
	while not HasModelLoaded(model) do
		RequestModel(model)
		
		Citizen.Wait(1)
	end
end

function spawnspeaker()
    local nearspeaker = false
    for k,v in pairs(props) do
        checkprop = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 3.0, GetHashKey(v))
        if checkprop ~= 0 and #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(checkprop)) < 15 then
            nearspeaker = true
            break
        end
    end
    if not nearspeaker then
        RequestAnimDict("pickup_object")
        while (not HasAnimDictLoaded("pickup_object")) do Citizen.Wait(0) end
        TaskPlayAnim(PlayerPedId(),"pickup_object","pickup_low", 1.0, -1.0, -1, 0, 1, true, true, true)
        ClearPedTasks(PlayerPedId())
        local s = CreateObject(`prop_speaker_06`, GetEntityCoords(PlayerPedId()), true, true, false)
        PlaceObjectOnGroundProperly(s)
        Citizen.Wait(2000)
        FreezeEntityPosition(s, true)
        table.insert(objects,s)
        return s
    else
        TriggerEvent('renzu_notify:Notify', 'error','MP3 Player', 'there is a nearest Mp3 Player')
    end
end

function CheckProp()
    Citizen.CreateThread(function()
        Citizen.Wait(1000)
        local pos
        while checkprop ~= 0 do
            for k,v in pairs(props) do
                checkprop = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 3.0, GetHashKey(v))
                if checkprop ~= 0 then
                    break
                end
            end
            Wait(1000)
        end
    end)
end

Citizen.CreateThread(function()
    Citizen.Wait(1000)
    local pos
    while true do
        local sleep = 2000
        for k,v in pairs(props) do
            checkprop = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 3.0, GetHashKey(v))
            if checkprop ~= 0 then
                break
            end
        end
        if checkprop ~= nil and checkprop ~= 0 then
            sleep = 5
            CheckProp()
            while checkprop ~= 0 do
                Citizen.Wait(sleep)
                local coord = GetEntityCoords(checkprop)
                DrawMarkerInput(coord,'Press [E] to Play 🎵 <br> Press [G] to Pick up 📻 ',checkprop)
                if IsControlJustReleased(1, 51) then
                    open = not open
                    SendNUIMessage({
                        open = "ui",
                        status = open
                    })
                    SetNuiFocus(open, open)
                end
                if IsControlJustReleased(1, 58) then
                    for k,v in pairs(props) do
                        checkprop = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 3.0, GetHashKey(v))
                        if checkprop ~= 0 then
                            break
                        end
                    end
                    ReqAndDelete(checkprop, false)
                    SendNUIMessage({
                        open = "ui",
                        status = false
                    })
                    break
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)

function ReqAndDelete(object, detach)
    print(object,DoesEntityExist(object))
    RequestAnimDict("pickup_object")
    while (not HasAnimDictLoaded("pickup_object")) do Citizen.Wait(0) end
    TaskPlayAnim(PlayerPedId(),"pickup_object","pickup_low", 1.0, -1.0, -1, 0, 1, true, true, true)
    ClearPedTasks(PlayerPedId())
	if DoesEntityExist(object) then
		NetworkRequestControlOfEntity(object)
		local attempt = 0
        FreezeEntityPosition(object,false)
		while not NetworkHasControlOfEntity(object) and DoesEntityExist(object) do
			NetworkRequestControlOfEntity(object)
			Citizen.Wait(11)
			attempt = attempt + 1
		end
		SetEntityAsMissionEntity(object, true, true)
		SetEntityAsNoLongerNeeded(object)
        DeleteObject(object)
        print("delete")
        if DoesEntityExist(object) then
            SetEntityCoords(object,vector3(0,0,0))
        end
	end
    local pos = GetEntityCoords(PlayerPedId())
    for k,v in pairs(musictable) do
        if xSound:soundExists(k) and #(pos - v.position) < 3 then
            xSound:Destroy(k)
            localplay[v.link] = false
            --play[k] = false
        end
    end
end

RegisterNUICallback('play',function(data)
	local pos = GetEntityCoords(PlayerPedId())
    playing = true
    tryingtoplay = data.url
    if IsPedInAnyVehicle(PlayerPedId(), false) then
        TriggerServerEvent("myevent:soundStatus", "play", VehToNet(GetVehiclePedIsIn(PlayerPedId(), false)), {type = 'vehicle', owner = GetPlayerServerId(PlayerId()), volume = 1.0, position = GetEntityCoords(PlayerPedId()), link = data.url })
    else
        if checkprop ~= nil and checkprop ~= 0 then
            prop = checkprop
        else
            prop = spawnspeaker()
        end
        local found = false
        for k,v in pairs(musictable) do
            local dis = #(GetEntityCoords(prop) - v.position)
            if dis < 5 then
                TriggerServerEvent("myevent:soundStatus", "play", v.owner, {type = v.type, owner = v.owner, volume = 1.0, position = GetEntityCoords(PlayerPedId()), link = data.url })
                found = true
                break
            end
        end
        if not found then
        TriggerServerEvent("myevent:soundStatus", "play", GetPlayerServerId(PlayerId()), {type = 'prop', owner = GetPlayerServerId(PlayerId()), volume = 1.0, position = GetEntityCoords(PlayerPedId()), link = data.url })
        end
    end
end)

RegisterNUICallback('volumeUp',function(data)
    local pos = GetEntityCoords(PlayerPedId())
    for k,v in pairs(musictable) do
        if v.owner == GetPlayerServerId(PlayerId()) and #(pos - v.position) < 3 then
            local volume = v.volume + 0.1
            if volume > 1 then
                volume = 1
            end
            TriggerServerEvent("myevent:soundStatus", "volume", k, {type = v.type, owner = v.owner, volume = volume, position = v.position, link = v.link })
        end
    end
end)

RegisterNUICallback('volumeDown',function(data)
	local pos = GetEntityCoords(PlayerPedId())
    for k,v in pairs(musictable) do
        if v.owner == GetPlayerServerId(PlayerId()) and #(pos - v.position) < 3 then
            local volume = v.volume - 0.1
            if volume < 0 then
                volume = 0
            end
            TriggerServerEvent("myevent:soundStatus", "volume", k, {type = v.type, owner = v.owner, volume = volume, position = v.position, link = v.link })
        end
    end
end)

RegisterNUICallback('focus',function(data)
    open = not open
	SetNuiFocus(open, open)
    open = not open
end)

RegisterNUICallback('pause',function(data)
	local pos = GetEntityCoords(PlayerPedId())
    for k,v in pairs(musictable) do
        if xSound:soundExists(k) and #(pos - v.position) < 3 then
            xSound:Pause(k)
            localplay[v.link] = false
            --play[k] = false
        end
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(1000)
    local pos
    while true do
        local pos = GetEntityCoords(PlayerPedId())
        for k,v in pairs(musictable) do
            if xSound:soundExists(k) then
                if #(pos - v.position) < 5 then
                    local duration = xSound:getTimeStamp(k)
                    local maxduration = xSound:getMaxDuration(k)
                    local percentage = (duration / maxduration) * 100
                    SendNUIMessage({
                        type = "duration",
                        setdur = duration,
                        percentage = percentage,
                        maxdur = maxduration
                    })
                end
            end
        end
        Citizen.Wait(1000)
    end
end)

RegisterNetEvent("myevent:soundStatus")
AddEventHandler("myevent:soundStatus", function(type, table)
    musictable = table
    local ped = PlayerPedId()
    local inveh = IsPedInAnyVehicle(ped, false)
    local checkprop
    if type == 'play' then
        checkprop = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 3.0, GetHashKey('prop_speaker_06'))
        if inveh then
            musicId = GetVehiclePedIsIn(ped, false)
        elseif checkprop ~= nil and checkprop ~= 0 and not inveh then
            musicId = checkprop
        end
    end

    for k,v in pairs(musictable) do
        if type == "position" then
            if xSound:soundExists(k) then
                xSound:Position(k, v.position)
            end
        end
        if type == "play" and #(GetEntityCoords(PlayerPedId()) - v.position) < 4 and not localplay[v.link] and xSound:soundExists(k) and xSound:getLink(k) ~= v.link then
            xSound:Destroy(k)
            localplay[v.link] = false
            play[k] = false
            Citizen.Wait(1000)
        end
        if type == "play" and not play[k] and not localplay[v.link] then
            play[k] = true
            localplay[v.link] = true
            local options = {
                onPlayStart = function(event) -- event argument returns getInfo(id)
            end,
                onPlayEnd = function(event)
                localplay[v.link] = false
                play[k] = false
            end,
            }  
            xSound:PlayUrlPos(k, v.link, v.volume, v.position, false, options)
            xSound:Distance(k, 20)
        end
        
        if type == "play" and xSound:soundExists(k) and xSound:isPaused(k) and #(GetEntityCoords(PlayerPedId()) - v.position) < 4 and not localplay[v.link] and tryingtoplay == v.link then
            xSound:Resume(k)
            localplay[v.link] = true
        end
    end
end)