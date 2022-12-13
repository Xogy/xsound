var soundList = [];
var closeToPlayer = [];
var isMutedAll = false;

var playerPos = [-90000,-90000,-90000];
$(function(){

    $.post('https://xsound/init');

	window.addEventListener('message', function(event) {
		var item = event.data;
        switch(item.status)
        {
            case "init":
                setInterval(updateVolumeSounds, item.time);
                break;
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
            /*
            case "textSpeech":
                var sound = soundList[item.name];

                if(sound != null)
                {
                    sound.destroyYoutubeApi();
                    sound.delete();
                    sound = null;
                }

                var sd = new SoundPlayer();
                sd.IsTextToSpeech(true)
                sd.setName(item.name);
                sd.setTextToSpeech(item.text)
                sd.setTextToSpeechLang(item.lang)
                sd.setDynamic(item.dynamic);
                sd.setLocation(item.x,item.y,item.z);
                sd.create();

                sd.setVolume(item.volume);
                sd.play();
                soundList[item.name] = sd;
                break;
            */
            case "url":
                var sound = soundList[item.name];

                if(sound != null)
                {
                    sound.destroyYoutubeApi();
                    sound.delete();
                    sound = null;
                }

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
                    delete soundList[item.name];
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
                    sound.unmute()
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
            case "unmuteAll":
                isMutedAll = false;
                for (var soundName in soundList)
                {
                    sound = soundList[soundName];
                    if(sound.isDynamic()){
                        sound.unmuteSilent();
                    }
                }
                updateVolumeSounds();
                break;
            case "muteAll":
                isMutedAll = true;
                for (var soundName in soundList)
                {
                    sound = soundList[soundName];
                    if(sound.isDynamic()){
                        sound.mute();
                    }
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
    if(!isMutedAll){
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
                    if(sound.loaded()) {
                        sound.mute();
                    }
                }
            }
        }
	}
}

setInterval(addToCache, 1000);

function updateVolumeSounds()
{
    if(!isMutedAll){
        var sound = null;
        for (var name in closeToPlayer)
        {
            sound = soundList[name];
            if(sound != null){
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
    }
}