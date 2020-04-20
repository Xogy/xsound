class SoundPlayer 
{
	constructor()
	{		
		this.url = "test";
		this.dynamic = false;
		this.distance = 10;
		this.volume = 1.0;
		this.pos = [0.0,0.0,0.0];
		this.max_volume = -1.0; 
		this.div_id = "myAudio_" + Math.floor(Math.random() * 9999999); 
	}

	getDistance(){ return this.distance;}
	getLocation(){ return this.pos;     }
	getUrlSound(){ return this.url;     }
    isDynamic  (){ return this.dynamic; }
    getDivId   (){ return this.div_id;  }
	getVolume  (){ return this.volume;  }
	
	setDistance(result)  { this.distance = result;}
	setDynamic(result)   { this.dynamic = result; }
	setLocation(x_,y_,z_){ this.pos = [x_,y_,z_]; }	
	setSoundUrl(result)  { this.url = result;     }
	setMaxVolume(result)  { this.max_volume = result; }
	setVolume(result)    
	{
		this.volume = result; 
		if(this.max_volume == -1) this.max_volume = result; 
		if(this.max_volume > (this.volume - 0.01)) this.volume = this.max_volume;	
		
		$("#" + this.div_id).prop("volume", result); 
	}

	create()
	{
		$("body").append("<audio id='"+ this.div_id +"' src='"+this.getUrlSound()+"' onended='$(this).deleteAudio();'></audio>");
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
            vol = (this.max_volume / 100) * far_away;
			this.setVolume(vol);
        }
        else this.setVolume(0);
	}
  
	play() 
	{
		$("#" + this.div_id).prop("volume", this.getVolume()); 
		$("#" + this.div_id)[0].play(); 
	}
	pause(){$("#" + this.div_id)[0].pause(); }	
	del()  {$("#" + this.div_id ).  remove();}
	
	resume(){$("#" + this.div_id)[0].play();}
	
	delete(){$("#" + this.div_id).remove(); }	
	
	mute  ()  {$("#" + this.div_id).prop("volume", 0);  }	
	unmute()  {$("#" + this.div_id).prop("volume", this.getVolume()); }
}