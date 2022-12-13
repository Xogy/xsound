class SoundPlayer
{
    static yPlayer = null;
    youtubeIsReady = false;

	constructor()
	{
		this.url = "test";
		this.name = "";
		this.dynamic = false;
		this.distance = 10;
		this.volume = 1.0;
		this.pos = [0.0,0.0,0.0];
		this.max_volume = -1.0; 
		this.div_id = "myAudio_" + Math.floor(Math.random() * 9999999);
		this.loop = false;
		this.isYoutube = false;
		this.load = false;
		this.isMuted_ = false;
		this.audioPlayer = null;

		//this.textToSpeech = false;
        //this.speechSynthMessage = new SpeechSynthesisUtterance();
		//this.textToRead = "hello you know";
		//this.textToReadLang = "en-US";
	}

    /*
    setTextToSpeechLang(lang){
        this.textToReadLang = lang;
    }

    setTextToSpeech(text){
        this.textToRead = text;
    }

    IsTextToSpeech(result){
        if(typeof result !== "undefined"){
            this.textToSpeech = result
        }
        return this.textToSpeech
    }
    */

	isYoutubeReady(result){
	    this.youtubeIsReady = result;
	}

	getDistance() { return this.distance;}
	getLocation() { return this.pos;     }
	getVolume()   { return this.volume;  }
	getMaxVolume(){ return this.max_volume;  }
	getUrlSound() { return this.url;     }
	isDynamic()   { return this.dynamic; }
	getDivId()    { return this.div_id;  }
	isLoop()      { return this.loop;    }
	getName()     { return this.name;    }
	loaded()      { return this.load;    }

	getAudioPlayer()    { return this.audioPlayer; }
	getYoutubePlayer()  { return this.yPlayer;     }

    setLoaded(result)    { this.load = result;   }
	setName(result)      { this.name = result;   }
	setDistance(result)  { this.distance = result;   }
	setDynamic(result)   { this.dynamic = result;    }
	setLocation(x_,y_,z_){ this.pos = [x_,y_,z_];    }


	setSoundUrl(result) {
	    this.url = result.replace(/<[^>]*>?/gm, '');
	}

	setLoop(result) {
        if(!this.isYoutube)
        {
            if(this.audioPlayer != null){
                this.audioPlayer.loop(result);
            }
        }
	    this.loop = result;
	}


	setMaxVolume(result) { this.max_volume = result; }
	setVolume(result)    
	{
		this.volume = result;
		if(this.max_volume == -1) this.max_volume = result; 
		if(this.max_volume > (this.volume - 0.01)) this.volume = this.max_volume;

        /*
		if(this.IsTextToSpeech()){
            this.speechSynthMessage.volume = result;
		    return;
		}
		*/

		if(this.dynamic && (this.isMuted_ || isMutedAll)){
			if(!this.isYoutube)
			{
				if(this.audioPlayer != null) {
				    this.audioPlayer.volume(0);
				}
			}
			else
			{
				if(this.yPlayer && this.youtubeIsReady){
				    this.yPlayer.setVolume(0);
				}
			}			
		}
		else
		{
			if(!this.isYoutube)
			{
				if(this.audioPlayer != null){
				    this.audioPlayer.volume(result);
				}
			}
			else
			{
				if(this.yPlayer && this.youtubeIsReady){
				    this.yPlayer.setVolume(result * 100);
				}
			}
		}
	}
  
	create()
	{
	    $.post('https://xsound/events', JSON.stringify(
	    {
            type: "onLoading",
            id: this.getName(),
	    }));
	    var link = getYoutubeUrlId(this.getUrlSound());
        if(link === "")
        {
            this.isYoutube = false;

            this.audioPlayer = new Howl({
                src: [this.getUrlSound()],
                loop: false,
                html5: true,
                autoplay: false,
                volume: 0.00,
                format: ['mp3'],
                onend: function(event){
                    ended(null);
                },
                onplay: function(){
                    isReady("nothing", true);
                },
            });
            $("#" + this.div_id).remove();
            $("body").append("<div id = '"+ this.div_id +"' style='display:none'>"+this.getUrlSound() +"</div>")
        }
        else
        {
            this.isYoutube = true;
            this.isYoutubeReady(false);
            $("#" + this.div_id).remove();
            $("body").append("<div id='"+ this.div_id +"'></div>");
            this.yPlayer = new YT.Player(this.div_id, {

                startSeconds:Number,

                videoId: link,
                origin: window.location.href,
                enablejsapi: 1,
                width: "0",
                height: "0",
		        playerVars: {
                    controls: 0,
                },
                events: {
                    'onReady': function(event){
                        event.target.unMute();
                        event.target.setVolume(0);
                        event.target.playVideo();
                        isReady(event.target.getIframe().id);
                    },
                    'onStateChange': function(event){
                        if (event.data == YT.PlayerState.ENDED) {
                            isLooped(event.target.getIframe().id);
                            ended(event.target.getIframe().id);
                        }
                    }
                }
            });
        }
	}

    destroyYoutubeApi()
    {
        if (this.yPlayer) {
            if (typeof this.yPlayer.stopVideo === "function" && typeof this.yPlayer.destroy === "function") {
                this.yPlayer.stopVideo();
                this.yPlayer.destroy();
                this.youtubeIsReady = false;
                this.yPlayer = null;
            }
        }
    }

	delete()
	{
	    if(this.audioPlayer != null){
            this.audioPlayer.pause();
            this.audioPlayer.stop();
            this.audioPlayer.unload();
	    }
	    this.audioPlayer = null;
	    $("#" + this.div_id).remove();
	}

	updateVolume(dd,maxd) 
	{
        var d_max = maxd;
        var d_now = dd;

        var vol = 0;

        var distance = (d_now / d_max);

        if (distance < 1)
        {
            distance = distance * 100;
            var far_away = 100 - distance;
            vol = (this.max_volume / 100) * far_away;;
			this.setVolume(vol);
			this.isMuted_ = false;
        }
        else
        {
            this.setVolume(0);
            this.isMuted_ = true;
        }
	}

	play() 
	{
	    /*
        if(this.IsTextToSpeech()){
            this.speechSynthMessage.lang = this.textToReadLang;
            this.speechSynthMessage.text = this.textToRead;
            window.speechSynthesis.speak(this.speechSynthMessage);
            return;
        }
        */

        if(!this.isYoutube)
        {
            if(this.audioPlayer != null){
                this.audioPlayer.play();
            }
        }
        else
        {
            if(this.youtubeIsReady){
                this.yPlayer.playVideo();
            }
        }
	}
	pause()
	{
        if(!this.isYoutube)
        {
            if(this.audioPlayer != null) this.audioPlayer.pause();
        }
        else
        {
            if(this.youtubeIsReady) this.yPlayer.pauseVideo();
        }
	}

	resume()
	{
        if(!this.isYoutube)
        {
            if(this.audioPlayer != null) this.audioPlayer.play();
        }
        else
        {
            if(this.youtubeIsReady) this.yPlayer.playVideo();
        }
	}

	isMuted()
	{
        return this.isMuted_;
	}

	mute()
	{
        this.isMuted_ = true;
        this.setVolume(0)
	}

	unmute()
	{
        this.isMuted_ = false;
        this.setVolume(this.getVolume())
	}

	unmuteSilent()
	{
        this.isMuted_ = false;
	}

	setTimeStamp(time)
	{
        if(!this.isYoutube)
        {
            this.audioPlayer.seek(time);
        }
        else
        {
            this.yPlayer.seekTo(time);
        }
	}

	isPlaying()
	{
        if(this.isYoutube) return this.youtubeIsReady && this.yPlayer.getPlayerState() == 1;
        else return this.audioPlayer != null  && this.audioPlayer.playing();
	}
}
