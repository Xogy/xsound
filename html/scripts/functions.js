function sanitizeURL(url) {
    url = DOMPurify.sanitize(url);
    return url.replace(/<[^>]*>?/gm, '');
}

function getYoutubeUrlId(url) {
    let videoId = "";
    if (url.indexOf("youtube") !== -1) {
        let urlParts = url.split("?v=");
        videoId = urlParts[1].substring(0, 11);
    }

    if (url.indexOf("youtu.be") !== -1) {
        let urlParts = url.replace("//", "").split("/");
        videoId = urlParts[1].substring(0, 11);
    }
    return videoId;
}

function isYoutubeURL(url) {
    return getYoutubeUrlId(url) !== "";
}

const maxDurationCache = {};
let durationProbeCounter = 0;

function postMaxDuration(soundName, url, time) {
    if (!time || !isFinite(time) || time <= 0) return;
    maxDurationCache[sanitizeURL(url)] = time;
    $.post('https://xsound/data_status', JSON.stringify({
        time: time,
        type: "maxDuration",
        id: soundName,
    }));
}

function getDurationOfMusicFromURL(url, timeStamp) {
    url = sanitizeURL(url);

    if (maxDurationCache[url]) {
        timeStamp(maxDurationCache[url]);
        return;
    }

    if (isYoutubeURL(url)) {
        if (typeof YT === "undefined" || !YT.Player) {
            timeStamp(null);
            return;
        }

        // One probe per lookup on its own div: YT's destroy() consumes the anchor
        // element, so a shared div only ever works once.
        const divId = "durationProbe_" + durationProbeCounter++;
        $("body").append("<div id='" + divId + "'></div>");

        let finished = false;
        let ytPlayer = null;
        let watchdog = null;

        const finish = (time) => {
            if (finished) return;
            finished = true;
            clearTimeout(watchdog);

            const player = ytPlayer;
            ytPlayer = null;

            let frame = null;
            try { if (player && typeof player.getIframe === "function") frame = player.getIframe(); } catch (e) { }
            if (!frame) frame = document.getElementById(divId);

            if (frame && frame.contentWindow) {
                frame.id = "";
                try { frame.src = "about:blank"; } catch (e) { }
                setTimeout(() => {
                    try { if (player && typeof player.destroy === "function") player.destroy(); } catch (e) { }
                    try { frame.remove(); } catch (e) { }
                }, 100);
            } else {
                try { if (player && typeof player.destroy === "function") player.destroy(); } catch (e) { }
                $("#" + divId).remove();
            }

            if (time && isFinite(time) && time > 0) {
                maxDurationCache[url] = time;
                timeStamp(time);
            } else {
                timeStamp(null);
            }
        };

        // a probe that never fires an event must not leave a live embed behind
        watchdog = setTimeout(() => finish(null), 15000);

        try {
            ytPlayer = new YT.Player(divId, {
                height: '0',
                width: '0',
                videoId: getYoutubeUrlId(url),
                events: {
                    'onReady': (event) => finish(event.target.getDuration()),
                    'onError': () => finish(null),
                }
            });
        } catch (e) {
            finish(null);
        }
    } else {
        let audioPlayer = new Howl({
            src: [ url ],
            loop: false,
            html5: true,
            autoplay: false,
            volume: 0.00,
            format: [ 'mp3' ],
            onload: () => {
                const time = audioPlayer.duration();
                if (time && isFinite(time) && time > 0) maxDurationCache[url] = time;
                timeStamp(time);
                audioPlayer.unload();
                audioPlayer = null;
            },
            onloaderror: (id, error) => {
                timeStamp(null);
                audioPlayer.unload();
                audioPlayer = null;
            },
        });
    }
}

function isReady(soundName) {
    const sound = soundList[soundName];
    if (sound == null) {
        return;
    }
    if (sound.loaded() == false) {
        sound.setLoaded(true);

        $.post('https://xsound/events', JSON.stringify({
            type: "onPlay",
            id: sound.getName(),
        }));

        if (sound.isAudioYoutubePlayer()) {
            sound.setYoutubePlayerReady(true);
        }

        if (sound.isDynamic()) {
            addToCache();
            updateVolumeSounds();
        } else {
            sound.setVolume(sound.getVolume())
        }
    }
}

function ended(soundName) {
    const sound = soundList[soundName];
    if (sound == null) {
        return;
    }
    if (!sound.isPlaying()) {
        if (sound.isLoop()) {
            const time = sound.getAudioCurrentTime();

            sound.setTimeStamp(0);
            sound.play();

            $.post('https://xsound/events', JSON.stringify({
                type: "resetTimeStamp",
                id: sound.getName(),
                time: time,
            }));
        }

        $.post('https://xsound/data_status', JSON.stringify({
            type: "finished",
            id: soundName
        }));
        $.post('https://xsound/events', JSON.stringify({
            type: "onEnd",
            id: sound.getName(),
        }));
    }
}

function sendMaxDurationToClient(item) {
    getDurationOfMusicFromURL(item.url, function (time) {
        if (time) {
            $.post('https://xsound/data_status', JSON.stringify({
                time: time,
                type: "maxDuration",
                id: item.name,
            }));
        }
    });
}