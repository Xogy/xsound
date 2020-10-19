function PlayUrl(source, name_, url_, volume_, loop_)
    TriggerClientEvent("xsound:stateSound", source, "play", {
        soundId = name_,
        url = url_,
        volume = volume_,
        loop = loop_
    })
end

exports('PlayUrl', PlayUrl)

function PlayUrlPos(source, name_, url_, volume_, pos, loop_)
    TriggerClientEvent("xsound:stateSound", source, "playpos", {
        soundId = name_,
        position = pos,
        url = url_,
        volume = volume_,
        loop = loop_
    })
end

exports('PlayUrlPos', PlayUrlPos)

function TextToSpeech(source, name_, lang, text, volume_, loop_)
    TriggerClientEvent("xsound:stateSound", source, "texttospeech", {
        soundId = name_,
        url = text,
        lang = lang,
        volume = volume_,
        loop = loop_
    })
end

exports('TextToSpeech', TextToSpeech)

function TextToSpeechPos(source, name_, lang, text, volume_, pos, loop_)
    TriggerClientEvent("xsound:stateSound", source, "texttospeechpos", {
        soundId = name_,
        lang = lang,
        position = pos,
        url = text,
        volume = volume_,
        loop = loop_
    })
end

exports('TextToSpeechPos', TextToSpeechPos)