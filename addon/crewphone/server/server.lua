if config.AddonList.crewPhone then
    RegisterServerEvent('muzik-cal')
    AddEventHandler('muzik-cal', function(pos, muzikAdi, link, serverId, mp3)
        TriggerClientEvent("client-muzik-cal", -1, pos, muzikAdi, link, serverId, mp3)
    end)

    RegisterServerEvent('muzik-durdur')
    AddEventHandler('muzik-durdur', function(muzikAdi)
        TriggerClientEvent("client-muzik-durdur", -1, muzikAdi)
    end)

    RegisterServerEvent('muzik-duraklat')
    AddEventHandler('muzik-duraklat', function(muzikAdi)
        TriggerClientEvent("client-muzik-duraklat", -1, muzikAdi)
    end)

    RegisterServerEvent('muzik-devamet')
    AddEventHandler('muzik-devamet', function(muzikAdi)
        TriggerClientEvent("client-muzik-devamet", -1, muzikAdi)
    end)

    AddEventHandler('playerDropped', function(source)
        local _source = source
        TriggerClientEvent("client-muzik-durdur", -1, tostring(_source))
    end)
end