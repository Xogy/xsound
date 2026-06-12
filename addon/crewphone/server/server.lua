if config.AddonList.crewPhone then
    local function isAllowedLink(link, mp3)
        if type(link) ~= "string" then return false end
        if mp3 then
            return link:match("^phone%-ring/[%w%-_%.]+$") ~= nil
        end
        return link:match("^https://www%.youtube%.com/watch%?v=[%w%-_]+$") ~= nil
    end

    RegisterServerEvent('muzik-cal')
    AddEventHandler('muzik-cal', function(pos, muzikAdi, link, serverId, mp3)
        local src = source
        if type(pos) ~= "table" then return end
        if not isAllowedLink(link, mp3) then return end

        TriggerClientEvent("client-muzik-cal", -1, pos, tostring(src), link, src, mp3)
    end)

    RegisterServerEvent('muzik-durdur')
    AddEventHandler('muzik-durdur', function(muzikAdi)
        TriggerClientEvent("client-muzik-durdur", -1, tostring(source))
    end)

    RegisterServerEvent('muzik-duraklat')
    AddEventHandler('muzik-duraklat', function(muzikAdi)
        TriggerClientEvent("client-muzik-duraklat", -1, tostring(source))
    end)

    RegisterServerEvent('muzik-devamet')
    AddEventHandler('muzik-devamet', function(muzikAdi)
        TriggerClientEvent("client-muzik-devamet", -1, tostring(source))
    end)

    AddEventHandler('playerDropped', function()
        local _source = source
        TriggerClientEvent("client-muzik-durdur", -1, tostring(_source))
    end)
end
