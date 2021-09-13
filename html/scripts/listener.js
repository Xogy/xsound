var soundList = [];
var closeToPlayer = [];

var playerPos = [-90000,-90000,-90000];
$(function(){
	window.addEventListener('message', function(event) {
		var item = event.data;
        switch(item.status)
        {
            case "position":
                playerPos = [item.x,item.y,item.z];
                break;

            case "volume":
                var sound = soundList[item.name];
                if(sound != null)
                {
                    sound.setVolume(item.volume);
                    sound.setMaxVolume(item.volume);
                }
                break;

            case "timestamp":
                var sound = soundList[item.name];
                if(sound != null)
                {
                    sound.setTimeStamp(item.timestamp);
                }
                break;

            case "max_volume":
                var sound = soundList[item.name];
                if(sound != null)
                {
                    sound.setMaxVolume(item.volume);
                }
                break;

            case "url":
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
                    sound.destroyYoutubeApi();
                    sound.delete();

                    sound.setLoaded(false);
                    sound.setName(item.name);
                    sound.setLocation(item.x,item.y,item.z);
                    sound.setLoop(item.loop);
                    sound.setSoundUrl(item.url);
                    sound.setMaxVolume(item.volume);
                    sound.setVolume(item.volume);
                    sound.create();

                    sound.play();
                }
                break;

            case "distance":
                var sound = soundList[item.name];
                if(sound != null)
                {
                    sound.setDistance(item.distance);
                }
                break;

            case "play":
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
                break;

            case "soundPosition":
                var sound = soundList[item.name];
                if(sound != null)
                {
                    sound.setLocation(item.x,item.y,item.z);
                }
                break;

            case "resume":
                var sound = soundList[item.name];
                if(sound != null)
                {
                    sound.resume();
                }
                break;

            case"pause":
                var sound = soundList[item.name];
                if(sound != null)
                {
                    sound.pause();
                }
                break;

            case "delete":
                var sound = soundList[item.name];
                if(sound != null)
                {
                    sound.destroyYoutubeApi();
                    sound.delete();
                }
                break;
            case "repeat":
                var sound = soundList[item.name];
                if(sound != null)
                {
                    sound.setTimeStamp(0);
                    sound.play();
                }
                break;
            case "changedynamic":
                var sound = soundList[item.name];
                if(sound != null)
                {
                    sound.setDynamic(item.bool);
                    sound.setVolume(sound.getMaxVolume());
                }
                break;
            case "changeurl":
                var sound = soundList[item.name];
                if(sound != null)
                {
                    sound.destroyYoutubeApi();
                    sound.delete();
                    sound.setSoundUrl(item.url);
                    sound.setLoaded(false);
                    sound.create();

                    sound.play();
                }
                break;
            case "loop":
                var sound = soundList[item.name];
                if(sound != null)
                {
                    sound.setLoop(item.loop);
                }
                break;
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

function addToCache()
{
    closeToPlayer = [];
    var sound = null;
	for (var soundName in soundList)
	{
		sound = soundList[soundName];
		if(sound.isDynamic())
		{
			var distance = Between(playerPos,sound.getLocation());
			var distance_max = sound.getDistance();
			if(distance < distance_max + 40)
			{
                closeToPlayer[soundName] = soundName;
			}
			else
			{
                if(!sound.isMuted() && sound.loaded()) {
                    sound.mute();
                }
			}
		}
	}
}

setInterval(addToCache, 1000);

function updateVolumeSounds()
{
    var sound = null;
    for (var name in closeToPlayer)
    {
        sound = soundList[name];
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

setInterval(updateVolumeSounds, refreshTime);