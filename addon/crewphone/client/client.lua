if config.AddonList.crewPhone then
    local calanMuzikler = {}
    local musicOn = false

    local ESX = nil

    CreateThread(function()
        xpcall(function()
            ESX = exports['es_extended']['getSharedObject']()
        end, function(error)
            while ESX == nil do
                Wait(50)
                TriggerEvent('esx:getSharedObject', function(obj)
                    ESX = obj
                end)
            end
        end)
    end)


    -- Müzik çalma
    exports('Cal', function(link, mp3)
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local serverId = GetPlayerServerId(PlayerId())
        local muzikAdi = tostring(serverId)

        if musicOn then
            TriggerServerEvent("muzik-durdur", muzikAdi)
            musicOn = false
        end

        if #calanMuzikler <= 99 then
            if mp3 then
                TriggerServerEvent("muzik-cal", pos, muzikAdi, "phone-ring/" .. link, serverId, true)
            else
                TriggerServerEvent("muzik-cal", pos, muzikAdi, "https://www.youtube.com/watch?v=" .. link, serverId, false)
            end
            musicOn = true
        else
            ESX.ShowNotification("Fazla kişi youtube uygulamasını kullandığı için açtığınız videonun sesini yakındaki kişiler duyamıyor", "error")
        end
    end)

    RegisterNetEvent('client-muzik-cal')
    AddEventHandler('client-muzik-cal', function(pos, muzikAdi, link, serverId, mp3)
        if tostring(GetPlayerServerId(PlayerId())) ~= muzikAdi then
            calanMuzikler[muzikAdi] = {}
            calanMuzikler[muzikAdi]["duraklat"] = false
            calanMuzikler[muzikAdi]["serverId"] = serverId
            calanMuzikler[muzikAdi]["mp3"] = mp3

            if mp3 then
                PlayUrlPos(muzikAdi, link, 0.1, pos)
                setVolumeMax(muzikAdi, 0.1)
                Distance(muzikAdi, 10)
            else
                PlayUrlPos(muzikAdi, link, 0.15, pos)
                setVolumeMax(muzikAdi, 0.15)
                Distance(muzikAdi, 15)
            end
        end
    end)

    -- Müzik durdurma
    exports('Durdur', function(link)
        if musicOn then
            musicOn = false
            TriggerServerEvent("muzik-durdur", tostring(GetPlayerServerId(PlayerId())))
        end
    end)

    RegisterNetEvent('client-muzik-durdur')
    AddEventHandler('client-muzik-durdur', function(muzikAdi)
        if GetPlayerServerId(PlayerId()) ~= muzikAdi then
            calanMuzikler[muzikAdi] = nil
            Destroy(muzikAdi)
        end
    end)

    -- Müzik duraklatma
    exports('Duraklat', function(link)
        local myId = tostring(GetPlayerServerId(PlayerId()))
        TriggerServerEvent("muzik-duraklat", myId)
    end)

    RegisterNetEvent('client-muzik-duraklat')
    AddEventHandler('client-muzik-duraklat', function(muzikAdi)
        if tostring(GetPlayerServerId(PlayerId())) ~= muzikAdi then
            if calanMuzikler[muzikAdi]["duraklat"] == false then
                calanMuzikler[muzikAdi]["duraklat"] = true
                Pause(muzikAdi)
            end
        end
    end)

    -- Müzik duraklatma
    exports('Devamet', function(link)
        local myId = tostring(GetPlayerServerId(PlayerId()))
        TriggerServerEvent("muzik-devamet", myId)
    end)

    RegisterNetEvent('client-muzik-devamet')
    AddEventHandler('client-muzik-devamet', function(muzikAdi)
        if tostring(GetPlayerServerId(PlayerId())) ~= muzikAdi then
            if calanMuzikler[muzikAdi]["duraklat"] == true then
                calanMuzikler[muzikAdi]["duraklat"] = false
                Resume(muzikAdi)
            end
        end
    end)

    -- Müzik Konum güncelleme
    local time = 100
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(time)

            for x, y in pairs(calanMuzikler) do
                local player = GetPlayerFromServerId(calanMuzikler[x]["serverId"])
                if player ~= -1 then
                    local ped = GetPlayerPed(player)
                    local kordinat = GetEntityCoords(ped)
                    local benimKordinat = GetEntityCoords(PlayerPedId())

                    local mesafe = #(benimKordinat - kordinat)
                    if mesafe < 200 then
                        time = 100
                        Position(x, kordinat)
                        if calanMuzikler[x]["mp3"] then
                            if IsPedInAnyVehicle(ped, true) == 1 then
                                local vehicle = GetVehiclePedIsIn(ped, false)
                                if GetEntitySpeed(vehicle) * 3.6 > 200.0 then
                                    Distance(x, 140)
                                elseif GetEntitySpeed(vehicle) * 3.6 > 150.0 then
                                    Distance(x, 125)
                                elseif GetEntitySpeed(vehicle) * 3.6 > 110.0 then
                                    Distance(x, 100)
                                elseif GetEntitySpeed(vehicle) * 3.6 > 90.0 then
                                    Distance(x, 80)
                                elseif GetEntitySpeed(vehicle) * 3.6 > 60.0 then
                                    Distance(x, 65)
                                elseif GetEntitySpeed(vehicle) * 3.6 > 30.0 then
                                    Distance(x, 40)
                                else
                                    Distance(x, 25)
                                end
                            else
                                Distance(x, 10)
                            end
                        else
                            if IsPedInAnyVehicle(ped, true) == 1 then
                                local vehicle = GetVehiclePedIsIn(ped, false)
                                if GetEntitySpeed(vehicle) * 3.6 > 200.0 then
                                    Distance(x, 140)
                                elseif GetEntitySpeed(vehicle) * 3.6 > 150.0 then
                                    Distance(x, 125)
                                elseif GetEntitySpeed(vehicle) * 3.6 > 110.0 then
                                    Distance(x, 100)
                                elseif GetEntitySpeed(vehicle) * 3.6 > 90.0 then
                                    Distance(x, 80)
                                elseif GetEntitySpeed(vehicle) * 3.6 > 60.0 then
                                    Distance(x, 65)
                                elseif GetEntitySpeed(vehicle) * 3.6 > 30.0 then
                                    Distance(x, 40)
                                else
                                    Distance(x, 25)
                                end
                            else
                                Distance(x, 15)
                            end
                        end

                    else
                        time = 2000
                        Position(x, kordinat)
                    end
                else
                    local muzikAdi = tostring(calanMuzikler[x]["serverId"])
                    calanMuzikler[muzikAdi] = nil
                    Destroy(muzikAdi)
                end
            end
        end
    end)
end