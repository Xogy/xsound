let identifierCounterVariable = 0;

class SoundPlayer {
    static yPlayer = null;
    youtubePlayerReady = false;

    constructor() {
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
                    $.post('https://xsound/events', JSON.stringify({ type: "onLoading", id: this.getName() }));
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
            this.isYoutube = true;
            this.setYoutubePlayerReady(false);
            $("#" + this.div_id).remove();
            $("body").append("<div id='" + this.div_id + "'></div>");
            this.yPlayer = new YT.Player(this.div_id, {

                startSeconds: Number,

                videoId: link,
                origin: window.location.href,
                enablejsapi: 1,
                width: "0",
                height: "0",
                playerVars: {
                    autoplay: 0,
                    controls: 0,
                    quality: 'auto',
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
                        if (event.data == YT.PlayerState.ENDED) {
                            ended(this.getName());
                        }
                    }
                }
            });
        }
    }

    destroyYoutubeApi() {
        if (this.yPlayer) {
            if (typeof this.yPlayer.stopVideo === "function" && typeof this.yPlayer.destroy === "function") {
                this.yPlayer.stopVideo();
                this.yPlayer.destroy();
                this.youtubePlayerReady = false;
                this.yPlayer = null;
            }
        }
    }

    delete() {
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
            this.audioPlayer.seek(time);
        } else {
            this.yPlayer.seekTo(time);
        }
    }

    isPlaying() {
        if (this.isAudioYoutubePlayer()) return this.isYoutubePlayerReady() && this.yPlayer.getPlayerState() == 1;
        else return this.audioPlayer != null && this.audioPlayer.playing();
    }
}
