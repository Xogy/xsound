let identifierCounterVariable = 0;

class SoundPlayer {
    constructor() {
        this.yPlayer = null;
        this.youtubePlayerReady = false;
        this.durationReported = false;
        this.apiWaitTries = 0;
        this.url = "test";
        this.name = "";
        this.dynamic = false;
        this.distance = 10;
        this.volume = 1.0;
        this.pos = [ 0.0, 0.0, 0.0 ];
        this.max_volume = -1.0;
        this.div_id = "myAudio_" + identifierCounterVariable++;
        this.loop = false;
        this.isYoutube = false;
        this.load = false;
        this.isMuted_ = false;
        this.audioPlayer = null;
    }

    setYoutubePlayerReady(result) {
        this.youtubePlayerReady = result;
    }

    isYoutubePlayerReady() {
        return this.youtubePlayerReady;
    }

    isAudioYoutubePlayer() {
        return this.isYoutube;
    }

    getDistance() {
        return this.distance;
    }

    getLocation() {
        return this.pos;
    }

    getVolume() {
        return this.volume;
    }

    getMaxVolume() {
        return this.max_volume;
    }

    getUrlSound() {
        return this.url;
    }

    isDynamic() {
        return this.dynamic;
    }

    getDivId() {
        return this.div_id;
    }

    isLoop() {
        return this.loop;
    }

    getName() {
        return this.name;
    }

    loaded() {
        return this.load;
    }

    getAudioPlayer() {
        return this.audioPlayer;
    }

    getYoutubePlayer() {
        return this.yPlayer;
    }

    getAudioCurrentTime() {
        if (this.isAudioYoutubePlayer()) {
            return this.getYoutubePlayer().getDuration();
        }
        return this.getAudioPlayer()._duration;
    }

    setLoaded(result) {
        this.load = result;
    }

    setName(result) {
        this.name = result;
    }

    setDistance(result) {
        this.distance = result;
    }

    setDynamic(result) {
        this.dynamic = result;
    }

    setLocation(x_, y_, z_) {
        this.pos = [ x_, y_, z_ ];
    }


    setSoundUrl(result) {
        this.url = sanitizeURL(result);
    }

    setLoop(result) {
        if (!this.isAudioYoutubePlayer()) {
            if (this.audioPlayer != null) {
                this.audioPlayer.loop(result);
            }
        }
        this.loop = result;
    }


    setMaxVolume(result) {
        this.max_volume = result;
    }

    setVolume(result) {
        this.volume = result;
        if (this.max_volume == -1) this.max_volume = result;
        if (this.max_volume > (this.volume - 0.01)) this.volume = this.max_volume;

        let volume = result;
        if (this.isDynamic() && (this.isMuted() || IsAllMuted)) volume = 0;

        if (this.isAudioYoutubePlayer() && this.yPlayer && this.isYoutubePlayerReady()) {
            this.yPlayer.setVolume(volume * 100);
        } else if (this.audioPlayer) {
            this.audioPlayer.volume(volume);
        }
    }

    create() {
        const link = getYoutubeUrlId(this.getUrlSound());
        this.durationReported = false;

        if (link === "") {
            this.isYoutube = false;

            this.audioPlayer = new Howl({
                src: [ this.getUrlSound() ],
                loop: false,
                html5: true,
                autoplay: false,
                volume: 0.00,
                format: [ 'mp3' ],
                onload: () => {
                    postMaxDuration(this.getName(), this.getUrlSound(), this.audioPlayer ? this.audioPlayer.duration() : 0);
                    $.post('https://xsound/events', JSON.stringify({ type: "onLoading", id: this.getName() }));
                },
                onloaderror: () => {
                    // a failed load must still reach the client's onEnd/destroyOnFinish
                    // path, otherwise the entry (and this Howl) is stranded forever
                    $.post('https://xsound/data_status', JSON.stringify({ type: "finished", id: this.getName() }));
                    $.post('https://xsound/events', JSON.stringify({ type: "onEnd", id: this.getName() }));
                },
                onend: () => {
                    ended(this.getName());
                },
                onplay: () => {
                    isReady(this.getName());
                },
            });
            $("#" + this.div_id).remove();
        } else {
            // iframe_api loads the widget API asynchronously; retry briefly instead of throwing
            if (typeof YT === "undefined" || !YT.Player) {
                if (this.apiWaitTries++ < 40) {
                    setTimeout(() => this.create(), 250);
                } else {
                    // API unreachable: report the sound as finished so the client
                    // runs its destroy path instead of waiting forever
                    $.post('https://xsound/data_status', JSON.stringify({ type: "finished", id: this.getName() }));
                    $.post('https://xsound/events', JSON.stringify({ type: "onEnd", id: this.getName() }));
                }
                return;
            }

            this.isYoutube = true;
            this.destroyYoutubeApi();
            this.setYoutubePlayerReady(false);
            $("#" + this.div_id).remove();
            $("body").append("<div id='" + this.div_id + "'></div>");
            this.yPlayer = new YT.Player(this.div_id, {
                videoId: link,
                width: "0",
                height: "0",
                playerVars: {
                    autoplay: 0,
                    controls: 0,
                    enablejsapi: 1,
                },
                events: {
                    'onReady': (event) => {
                        event.target.unMute();
                        event.target.setVolume(0);
                        event.target.playVideo();
                        isReady(this.getName());
                        $.post('https://xsound/events', JSON.stringify({ type: "onLoading", id: this.getName() }));
                    },
                    'onStateChange': (event) => {
                        // getDuration() is only reliable once playback has started
                        if (event.data == YT.PlayerState.PLAYING && !this.durationReported) {
                            const duration = event.target.getDuration();
                            if (duration && isFinite(duration) && duration > 0) {
                                this.durationReported = true;
                                postMaxDuration(this.getName(), this.getUrlSound(), duration);
                            }
                        }
                        if (event.data == YT.PlayerState.ENDED) {
                            ended(this.getName());
                        }
                    },
                    'onError': () => {
                        // a dead video must not keep a live embed attached, and the
                        // client still needs finished/onEnd to run its destroy path
                        this.destroyYoutubeApi();
                        $.post('https://xsound/data_status', JSON.stringify({ type: "finished", id: this.getName() }));
                        $.post('https://xsound/events', JSON.stringify({ type: "onEnd", id: this.getName() }));
                    }
                }
            });
        }
    }

    destroyYoutubeApi() {
        const player = this.yPlayer;
        if (!player) return;
        this.yPlayer = null;
        this.youtubePlayerReady = false;

        // stopVideo() only exists once the iframe handshake has completed, but the
        // player must be released either way — never gate destruction on readiness
        let frame = null;
        try { if (typeof player.getIframe === "function") frame = player.getIframe(); } catch (e) { }
        if (!frame) frame = document.getElementById(this.div_id);

        try { if (typeof player.stopVideo === "function") player.stopVideo(); } catch (e) { }

        if (frame && frame.contentWindow) {
            // Navigate the embed to about:blank before detaching it: CEF does not
            // promptly release the document of an iframe removed while live. The id
            // is cleared so delete()'s selector cannot remove it mid-navigation.
            frame.id = "";
            try { frame.src = "about:blank"; } catch (e) { }
            setTimeout(() => {
                try { if (typeof player.destroy === "function") player.destroy(); } catch (e) { }
                try { frame.remove(); } catch (e) { }
            }, 100);
        } else {
            try { if (typeof player.destroy === "function") player.destroy(); } catch (e) { }
        }
    }

    delete() {
        this.destroyYoutubeApi();
        if (this.audioPlayer != null) {
            this.audioPlayer.pause();
            this.audioPlayer.stop();
            this.audioPlayer.unload();
        }
        this.audioPlayer = null;
        $("#" + this.div_id).remove();
    }

    updateVolume(dd, maxd) {
        const d_max = maxd;
        const d_now = dd;
        let vol = 0;
        let distance = (d_now / d_max);
        if (distance < 1) {
            distance = distance * 100;
            const far_away = 100 - distance;
            vol = (this.max_volume / 100) * far_away;
            this.setVolume(vol);
            this.isMuted_ = false;
        } else {
            this.setVolume(0);
            this.isMuted_ = true;
        }
    }

    play() {
        if (!this.isAudioYoutubePlayer()) {
            if (this.audioPlayer != null) {
                this.audioPlayer.play();
            }
        } else {
            if (this.isYoutubePlayerReady()) {
                this.yPlayer.playVideo();
            }
        }
    }

    pause() {
        if (!this.isAudioYoutubePlayer()) {
            if (this.audioPlayer != null) this.audioPlayer.pause();
        } else {
            if (this.isYoutubePlayerReady()) this.yPlayer.pauseVideo();
        }
    }

    resume() {
        if (!this.isAudioYoutubePlayer()) {
            if (this.audioPlayer != null) this.audioPlayer.play();
        } else {
            if (this.isYoutubePlayerReady()) this.yPlayer.playVideo();
        }
    }

    isMuted() {
        return this.isMuted_;
    }

    mute() {
        this.isMuted_ = true;
        this.setVolume(0)
    }

    unmute() {
        this.isMuted_ = false;
        this.setVolume(this.getVolume())
    }

    unmuteSilent() {
        this.isMuted_ = false;
    }

    setTimeStamp(time) {
        if (!this.isAudioYoutubePlayer()) {
            if (this.audioPlayer != null) this.audioPlayer.seek(time);
        } else if (this.yPlayer && this.isYoutubePlayerReady()) {
            this.yPlayer.seekTo(time);
        }
    }

    isPlaying() {
        if (this.isAudioYoutubePlayer()) return this.isYoutubePlayerReady() && this.yPlayer.getPlayerState() == 1;
        else return this.audioPlayer != null && this.audioPlayer.playing();
    }
}
