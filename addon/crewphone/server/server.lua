if config.AddonList.crewPhone then
    RegisterServerEvent('muzik-cal')
    AddEventHandler('muzik-cal', function(pos, muzikAdi, link, serverId, mp3)
        local src <const> = source
        if type(pos) ~= "vector3" and type(pos) ~= "table" then return end
        local data = mp3 and { volume = 1.0 } or { url = link, volume = 1.0 }
        local ok = Security.check(src, 'broadcast', data)
        if not ok then return end
        TriggerClientEvent("client-muzik-cal", -1, pos, muzikAdi, link, serverId, mp3)
    end)

    RegisterServerEvent('muzik-durdur')
    AddEventHandler('muzik-durdur', function(muzikAdi)
        if not Security.allowed(source) then return end
        TriggerClientEvent("client-muzik-durdur", -1, muzikAdi)
    end)

    RegisterServerEvent('muzik-duraklat')
    AddEventHandler('muzik-duraklat', function(muzikAdi)
        if not Security.allowed(source) then return end
        TriggerClientEvent("client-muzik-duraklat", -1, muzikAdi)
    end)

    RegisterServerEvent('muzik-devamet')
    AddEventHandler('muzik-devamet', function(muzikAdi)
        if not Security.allowed(source) then return end
        TriggerClientEvent("client-muzik-devamet", -1, muzikAdi)
    end)

    AddEventHandler('playerDropped', function()
        local src <const> = source
        TriggerClientEvent("client-muzik-durdur", -1, tostring(src))
    end)
end
