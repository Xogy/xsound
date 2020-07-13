var soundList = [];
var playingRightNow = [];

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

        if(item.status === "timestamp")
        {
            var sound = soundList[item.name];
            if(sound != null)
            {
                sound.setTimeStamp(item.timestamp);
            }
        }

        if(item.status === "max_volume")
        {
            var sound = soundList[item.name];
            if(sound != null)
            {
                sound.setMaxVolume(item.volume);
            }
        }

		if (item.status === "url")
		{
			var sound = soundList[item.name];

			if(sound == null)
			{
				var sd = new SoundPlayer();
				sd.setName(item.name);
				sd.setSoundUrl(item.url);
				sd.setDynamic(item.dynamic);
				sd.setLocation(item.x,item.y,item.z);
				sd.setLoop(item.loop)
				sd.create();
				sd.setVolume(item.volume);
				sd.play();
				soundList[item.name] = sd;
				}else{
				sound.setName(item.name);
				sound.setLocation(item.x,item.y,item.z);
				sound.setSoundUrl(item.url);
				sound.setLoop(item.loop);
				sound.destroyYoutubeApi();
				sound.delete();
				sound.create();
				sound.setVolume(item.volume);
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
			    sound.destroyYoutubeApi();
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

function updateVolumeSounds(test)
{
	for (var soundName in soundList)
	{
		var sound = soundList[soundName];
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

setInterval(updateVolumeSounds, 50);