const soundList = [];
let closeToPlayer = [];
var IsAllMuted = false;

let updateVolumeSoundTimer;
let updateCacheTimer;

let playerPos = [ -90000, -90000, -90000 ];

let refreshTime = 300;

$(function () {
    $.post('https://xsound/init');

    window.addEventListener('message', function (event) {
        const item = event.data;
        let sound;
        let sd;
        switch (item.status) {
            case "init":
                refreshTime = item.time;
                break;
            case "position":
                playerPos = [ item.x, item.y, item.z ];
                break;

            case "volume":
                sound = soundList[item.name];
                if (sound != null) {
                    sound.setVolume(item.volume);
                    sound.setMaxVolume(item.volume);
                }
                break;

            case "timestamp":
                sound = soundList[item.name];
                if (sound != null) {
                    sound.setTimeStamp(item.timestamp);
                }
                break;

            case "max_volume":
                sound = soundList[item.name];
                if (sound != null) {
                    sound.setMaxVolume(item.volume);
                }
                break;
            case "url":
                sound = soundList[item.name];

                if (sound != null) {
                    sound.destroyYoutubeApi();
                    sound.delete();
                    sound = null;
                }

                sd = new SoundPlayer();

                sendMaxDurationToClient(item);

                sd.setName(item.name);
                sd.setSoundUrl(item.url);
                sd.setDynamic(item.dynamic);
                sd.setLocation(item.x, item.y, item.z);
                sd.setLoop(item.loop)
                sd.create();
                sd.setVolume(item.volume);
                sd.play();
                soundList[item.name] = sd;
                break;

            case "distance":
                sound = soundList[item.name];
                if (sound != null) {
                    sound.setDistance(item.distance);
                }
                break;

            case "play":
                sound = soundList[item.name];
                if (sound != null) {
                    sound.delete();
                    sound.create();
                    sound.setVolume(item.volume);
                    sound.setDynamic(item.dynamic);
                    sound.setLocation(item.x, item.y, item.z);
                    sound.play();
                }
                break;

            case "soundPosition":
                sound = soundList[item.name];
                if (sound != null) {
                    sound.setLocation(item.x, item.y, item.z);
                }
                break;

            case "resume":
                sound = soundList[item.name];
                if (sound != null) {
                    sound.resume();
                }
                break;

            case"pause":
                sound = soundList[item.name];
                if (sound != null) {
                    sound.pause();
                }
                break;

            case "delete":
                sound = soundList[item.name];
                if (sound != null) {
                    sound.destroyYoutubeApi();
                    sound.delete();
                    delete soundList[item.name];
                }
                break;
            case "repeat":
                sound = soundList[item.name];
                if (sound != null) {
                    sound.setTimeStamp(0);
                    sound.play();
                }
                break;
            case "changedynamic":
                sound = soundList[item.name];
                if (sound != null) {
                    sound.unmute()
                    sound.setDynamic(item.bool);
                    sound.setVolume(sound.getMaxVolume());
                }
                break;
            case "changeurl":
                sound = soundList[item.name];
                if (sound != null) {
                    sound.destroyYoutubeApi();
                    sound.delete();

                    sendMaxDurationToClient(item);

                    sound.setSoundUrl(item.url);
                    sound.setLoaded(false);
                    sound.create();

                    sound.play();
                }
                break;
            case "loop":
                sound = soundList[item.name];
                if (sound != null) {
                    sound.setLoop(item.loop);
                }
                break;
            case "unmuteAll":
                IsAllMuted = false;
                for (let soundName in soundList) {
                    sound = soundList[soundName];
                    if (sound.isDynamic()) {
                        sound.unmuteSilent();
                    }
                }
                updateVolumeSounds();

                if (!updateVolumeSoundTimer) {
                    updateVolumeSoundTimer = setInterval(addToCache, 1000);
                }
                if (!updateCacheTimer) {
                    updateCacheTimer = setInterval(updateVolumeSounds, refreshTime);
                }
                break;
            case "muteAll":
                IsAllMuted = true;
                for (let soundName in soundList) {
                    sound = soundList[soundName];
                    if (sound.isDynamic()) {
                        sound.mute();
                    }
                }

                clearInterval(updateVolumeSoundTimer);
                clearInterval(updateCacheTimer);

                updateVolumeSoundTimer = null;
                updateCacheTimer = null;
                break;
        }
    })
});

function between(loc1, loc2) {
    const deltaX = loc1[0] - loc2[0];
    const deltaY = loc1[1] - loc2[1];
    const deltaZ = loc1[2] - loc2[2];

    return Math.sqrt(deltaX * deltaX + deltaY * deltaY + deltaZ * deltaZ);
}

function addToCache() {
    if (!IsAllMuted) {
        closeToPlayer = [];
        let sound = null;
        for (const soundName in soundList) {
            sound = soundList[soundName];
            if (sound.isDynamic()) {
                const distance = between(playerPos, sound.getLocation());
                const distance_max = sound.getDistance();
                if (distance < distance_max + 40) {
                    closeToPlayer.push(sound);
                } else {
                    if (sound.loaded()) {
                        sound.mute();
                    }
                }
            }
        }
    }
}

function updateVolumeSounds() {
    if (!IsAllMuted) {
        for (let sound of closeToPlayer) {
            if (sound && sound.isDynamic()) {
                const distance = between(playerPos, sound.getLocation());
                const distance_max = sound.getDistance();
                if (distance < distance_max) {
                    sound.updateVolume(distance, distance_max);
                } else {
                    sound.mute();
                }
            }
        }
    }
}