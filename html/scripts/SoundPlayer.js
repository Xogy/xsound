function isReady(divId){
	for (var soundName in soundList)
	{
		var sound = soundList[soundName];
        if(sound.getDivId() === divId){
            sound.isYoutubeReady(true);
            if(!sound.isDynamic()) sound.setVolume(sound.getVolume())
            if(sound.isDynamic())  sound.setMaxVolume(sound.getVolume())
            break;
        }
	}
}

function isLooped(divId){
	for (var soundName in soundList)
	{
		var sound = soundList[soundName];
        if(sound.getDivId() === divId && sound.isLoop() == true){
            sound.destroyYoutubeApi();
            sound.delete();
            sound.create();
            sound.play();
            break;
        }
    }
}

function ended(divId){
    if(divId == null)
    {
    	for (var soundName in soundList)
    	{
            var sound = soundList[soundName];
            if(!sound.isPlaying())
            {
                $.post('http://xsound/data_status', JSON.stringify({ type: "finished",id: soundName }));
                break;
            }
    	}
    }
    else
    {
    	for (var soundName in soundList)
    	{
            var sound = soundList[soundName];
            if(sound.getDivId() === divId && sound.isLoop() == false){
                sound.destroyYoutubeApi();
                $.post('http://xsound/data_status', JSON.stringify({ type: "finished",id: soundName }));
                break;
            }
        }
    }
}

class SoundPlayer
{
    static yPlayer = null;
    youtubeIsReady = false;
	constructor()
	{
		this.url = "test";
		this.dynamic = false;
		this.distance = 10;
		this.volume = 1.0;
		this.pos = [0.0,0.0,0.0];
		this.max_volume = -1.0; 
		this.div_id = "myAudio_" + Math.floor(Math.random() * 9999999);
		this.loop = false;
		this.isYoutube = false;
		this.audioPlayer = null;
	}

	isYoutubeReady(result){
	    this.youtubeIsReady = result;
	}

	getDistance(){ return this.distance;}
	getLocation(){ return this.pos;     }
	getVolume  (){ return this.volume;  }
	getUrlSound(){ return this.url;     }
	isDynamic()  { return this.dynamic; }
	getDivId()   { return this.div_id;  }
	isLoop()     { return this.loop;    }
	
	setDistance(result)  { this.distance = result;   }
	setDynamic(result)   { this.dynamic = result;    }
	setLocation(x_,y_,z_){ this.pos = [x_,y_,z_];    }
	setSoundUrl(result)  { this.url = result;        }
	setLoop(result)      { this.loop = result;       }
	setMaxVolume(result) { this.max_volume = result; }
	setVolume(result)    
	{
		this.volume = result;
		if(this.max_volume == -1) this.max_volume = result; 
		if(this.max_volume > (this.volume - 0.01)) this.volume = this.max_volume;
        if(!this.isYoutube)
        {
            this.audioPlayer.volume(result);
        }
        else
        {
            if(this.yPlayer && this.youtubeIsReady) this.yPlayer.setVolume(result * 100);
        }
	}
  
	create()
	{
	    var link = getYoutubeUrlId(this.getUrlSound());
        if(link === "")
        {
            this.isYoutube = false;

            this.audioPlayer = new Howl({
                src: [this.getUrlSound()],
                loop: this.isLoop(),
                onend: function(event){
                    ended(null);
                }
            });
        }
        else
        {
            this.isYoutube = true;
            this.isYoutubeReady(false);
            $("body").append("<div id='"+ this.div_id +"'></div>");
            this.yPlayer = new YT.Player(this.div_id, {
                videoId: link,
                origin: window.location.href,
                enablejsapi: 1,
                width: "0",
                height: "0",
                events: {
                    'onReady': function(event){
                        event.target.playVideo();
                        isReady(event.target.getIframe().id);
                    },
                    'onStateChange': function(event){
                        if (event.data == YT.PlayerState.ENDED) {
                            isLooped(event.target.getIframe().id);
                        }

                        if (event.data == YT.PlayerState.ENDED) {
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
            this.yPlayer.stopVideo();
            this.yPlayer.destroy();
            this.youtubeIsReady = false;
            this.yPlayer = null;
        }
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
        }
        else this.setVolume(0);
	}

	play() 
	{
        if(!this.isYoutube)
        {
            this.audioPlayer.volume(this.getVolume());
            this.audioPlayer.play();
        }
        else
        {
            if(this.youtubeIsReady) this.yPlayer.playVideo();
        }
	}
	pause()
	{
        if(!this.isYoutube)
        {
            this.audioPlayer.pause();
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
            this.audioPlayer.play();
        }
        else
        {
            if(this.youtubeIsReady) this.yPlayer.playVideo();
        }
	}

	delete()
	{
	    this.audioPlayer.pause();
	    this.audioPlayer = null;
	}
	
	mute  ()
	{
        if(!this.isYoutube)
        {
            this.audioPlayer.volume(0);
        }
        else
        {
            if(this.youtubeIsReady) this.yPlayer.setVolume(0);
        }
	}
	unmute()
	{
        if(!this.isYoutube)
        {
            this.audioPlayer.volume(this.getVolume());
        }
        else
        {
            if(this.youtubeIsReady) this.yPlayer.setVolume( this.getVolume() * 100);
        }
	}

	isPlaying()
	{
        if(!this.isYoutube)
        {
            return this.audioPlayer.playing();
        }
        return false;
	}
}