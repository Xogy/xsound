var soundList = [];
var playingRightNow = [];
for (i = 0; i < musicList.length; i++) 
{
	var sound = new SoundPlayer();
	var name = musicList[i][1];
	var distance = musicList[i][2];
	
	sound.setSoundUrl(musicList[i][0]);
	//sound.setDynamic (musicList[i][1]);
	
	sound.setDistance(distance);
	
	soundList[name] = sound;
}

var playerPos = [0,0,0];
$(function(){
	window.addEventListener('message', function(event) {
		var item = event.data;
		if(item.status === "position")
		{
			playerPos = [item.x,item.y,item.z];
		}

		if(item.status === "volume")
        {
            var sound = soundList[item.name];
			if(sound != null)
			{
                sound.setVolume(item.volume);
                sound.setMaxVolume(item.volume);
            }
        }

		if (item.status === "url") 
		{
			var sound = soundList[item.name];	
						
			if(sound == null)
			{
				var sd = new SoundPlayer();
				sd.setSoundUrl(item.url);		
				sd.setVolume(item.volume);											
				sd.setDynamic(item.dynamic);
				sd.setLocation(item.x,item.y,item.z);
				sd.setLoop(item.loop)
				sd.create();				
				sd.play();
				soundList[item.name] = sd;
				}else{				
				sound.setLocation(item.x,item.y,item.z);
				sound.setSoundUrl(item.url);
				sound.setLoop(item.loop)
				sound.delete();
				sound.create();
				sound.play();
			}
		}
		
		if (item.status === "distance") 
		{
			var sound = soundList[item.name];		
			if(sound != null)
			{
				sound.setDistance(item.distance);
			}
		}
		
		if (item.status === "play") 
		{
			var sound = soundList[item.name];		
			if(sound != null)
			{
				sound.delete();
				sound.create();
				sound.setVolume(item.volume);
				sound.setDynamic(item.dynamic);
				sound.setLocation(item.x,item.y,item.z);
				sound.play();
			}
		}
		
		if (item.status === "soundPosition") 
		{
			var sound = soundList[item.name];		
			if(sound != null)
			{
				sound.setLocation(item.x,item.y,item.z);
			}
		}
		
		if (item.status === "resume") 
		{
			var sound = soundList[item.name];		
			if(sound != null)
			{
				sound.resume();
			}
		}
		
		if (item.status === "pause") 
		{
			var sound = soundList[item.name];		
			if(sound != null)
			{
				sound.pause();
			}
		}
		
		if (item.status === "delete") 
		{
			var sound = soundList[item.name];		
			if(sound != null)
			{
				sound.delete();
			}
		}
    })	
});  	

function Between(loc1,loc2)
{	
	var deltaX = loc1[0] - loc2[0];
	var deltaY = loc1[1] - loc2[1];
	var deltaZ = loc1[2] - loc2[2];

	var distance = Math.sqrt(deltaX * deltaX + deltaY * deltaY + deltaZ * deltaZ);
	return distance;
}

setInterval(myMethod, 100);

function myMethod()
{
	for (var ss in soundList)
	{
		var sound = soundList[ss];
		if(sound.isDynamic())
		{
			var distance = Between(playerPos,sound.getLocation());
			var distance_max = sound.getDistance();
			if(distance < distance_max)
			{
				sound.updateVolume(distance,distance_max);
				continue;
			}
			sound.mute();
		}
	}
}
























