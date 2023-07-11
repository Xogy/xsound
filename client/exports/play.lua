function PlayUrl(name_, url_, volume_, loop_, options)
    if disableMusic then return end

    if soundInfo[name_] == nil then soundInfo[name_] = getDefaultInfo() end

    soundInfo[name_].volume = volume_
    soundInfo[name_].url = url_
    soundInfo[name_].id = name_
    soundInfo[name_].playing = true
    soundInfo[name_].loop = loop_ or false
    soundInfo[name_].isDynamic = false

    globalOptionsCache[name_] = options or { }

    if loop_ then
        soundInfo[name_].destroyOnFinish = false
    else
        soundInfo[name_].destroyOnFinish = true
    end

    CheckForCloseMusic()
    UpdatePlayerPositionInNUI()
    SendNUIMessage({ status = "unmuteAll" })

    SendNUIMessage({
        status = "url",
        name = name_,
        url = url_,
        x = 0,
        y = 0,
        z = 0,
        dynamic = false,
        volume = volume_,
        loop = loop_ or false,
    })
end

exports('PlayUrl', PlayUrl)

function PlayUrlPos(name_, url_, volume_, pos, loop_, options)
    if disableMusic then return end

    if soundInfo[name_] == nil then soundInfo[name_] = getDefaultInfo() end

    soundInfo[name_].volume = volume_
    soundInfo[name_].url = url_
    soundInfo[name_].position = pos
    soundInfo[name_].id = name_
    soundInfo[name_].playing = true
    soundInfo[name_].loop = loop_ or false
    soundInfo[name_].isDynamic = true

    globalOptionsCache[name_] = options or { }

    CheckForCloseMusic()

    if #(GetEntityCoords(PlayerPedId()) - pos) < 10.0 + config.distanceBeforeUpdatingPos then
        UpdatePlayerPositionInNUI()
        SendNUIMessage({ status = "unmuteAll" })
    end

    SendNUIMessage({
        status = "url",
        name = name_,
        url = url_,
        x = pos.x,
        y = pos.y,
        z = pos.z,
        dynamic = true,
        volume = volume_,
        loop = loop_ or false,
    })

    if loop_ then
        soundInfo[name_].destroyOnFinish = false
    else
        soundInfo[name_].destroyOnFinish = true
    end
end

exports('PlayUrlPos', PlayUrlPos)

function PlayUrlPosSilent(name_, url_, volume_, pos, loop_)
    if disableMusic then return end
    SendNUIMessage({
        status = "url",
        name = name_,
        url = url_,
        x = pos.x,
        y = pos.y,
        z = pos.z,
        dynamic = true,
        volume = volume_,
        loop = loop_ or false,
    })
end

--function TextToSpeech(name_, lang, text, volume_)
--    if disableMusic then return end
--    SendNUIMessage({
--        status = "textSpeech",
--        name = name_,
--        text = text,
--        lang = lang,
--        x = 0,
--        y = 0,
--        z = 0,
--        dynamic = false,
--        volume = volume_,
--    })
--
--    if soundInfo[name_] == nil then soundInfo[name_] = getDefaultInfo() end
--
--    soundInfo[name_].volume = volume_
--    soundInfo[name_].url = "is text to speech"
--    soundInfo[name_].id = name_
--    soundInfo[name_].playing = true
--    soundInfo[name_].loop = false
--    soundInfo[name_].isDynamic = false
--    soundInfo[name_].destroyOnFinish = true
--
--
--    globalOptionsCache[name_] = options or { }
--end
--
--exports('TextToSpeech', TextToSpeech)

--function TextToSpeechPos(name_, lang, text, volume_, pos)
--    if disableMusic then return end
--    SendNUIMessage({
--        status = "textSpeech",
--        name = name_,
--        text = text,
--        lang = lang,
--        x = pos.x,
--        y = pos.y,
--        z = pos.z,
--        dynamic = true,
--        volume = volume_,
--    })
--
--    if soundInfo[name_] == nil then soundInfo[name_] = getDefaultInfo() end
--
--    soundInfo[name_].volume = volume_
--    soundInfo[name_].url = "is text to speech"
--    soundInfo[name_].position = pos
--    soundInfo[name_].id = name_
--    soundInfo[name_].playing = true
--    soundInfo[name_].loop = false
--    soundInfo[name_].isDynamic = true
--    soundInfo[name_].destroyOnFinish = true
--
--
--    globalOptionsCache[name_] = options or { }
--end
--
--exports('TextToSpeechPos', TextToSpeechPos)