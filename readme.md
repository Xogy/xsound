😍 Checkout our store for more amazing resources https://store.rcore.cz/ <br>
🎵 Resources using this API https://store.rcore.cz/category/music

# Improved audio library for FiveM

Can work with API interact sound<br>
Just make sure you take all sounds from interact<br>
sound and move them to xsound/html/sounds

Thanks to<br>
https://github.com/plunkettscott<br>
for awesome api<br>
https://github.com/plunkettscott/interact-sound<br>

### SoundSystem functions

**1. Functions (client side)**

------------

### Playing sound

------------

   - `PlayUrl(name, URL, volume, loop, options)`<br>Will play sound from URL (can be heard everywhere)<br>argument loop and options are optional, doesn't have to be used.
      
   - `PlayUrlPos(name, url, volume, Vector3 vec, loop, options)` <br>Will play sound from url at x,y,z location <br>argument loop and options are optional, doesn't have to be used.
   
   options list
   - onPlayStart
   - onPlayEnd
   - onLoading
   - onPlayPause
   - onPlayResume
   
------------

### Manipulation with sound

------------

   - `Position(name, Vector3 vec)`<br>Will update location of sound
   
   - `Distance(name, newDistance)`<br>Will set new playing distance from location
     
   - `Destroy(name)`<br>Will destroy sound
     
   - `Pause(name)`<br>Will pause sound
     
   - `Resume(name)`<br>Will resume sound       
     
   - `setVolume(name,volume)` volume is from 0.0 to 1.0<br>Will set a new value to volume. Should be used for non 3D sound
     
   - `setVolumeMax(name,volume)` volume is from 0.0 to 1.0<br>will set new value to max volume. Should be used only for 3D sound
   
   - `setTimeStamp(name, time)` will set a new timestamp.
   
   - `setSoundURL(name, url)` will set new URL to sound (will play whenever changed)
   
   - `repeatSound(name)` will play again the saved sound
   
   - `destroyOnFinish(name, bool)` true = destroy on end / false = do not destroy on end
   
   - `setSoundLoop(name, bool)` will set a new value to loop
   
   - `setSoundDynamic(name, bool)`  will set if the sound is 3D / 3D = true
   
------------
   
### Effects on sound

------------
   
   - `fadeOut(name, time)`
   - `fadeIn(name, time, volume)`

------------

### Events (client side only)

------------

   - `onPlayStart(name, function)`
   <br>This event will trigger after the sound
   <br>is loaded and start playing in game.
   
   - `onPlayEnd(name, function)`
   <br>This event will be triggered after sound end.
   
   - `onLoading(name, function)`
   <br>This event will be triggered when the sound start loading.
   - `onPlayPause(name, function)`
   <br>This event will be triggered whenever you pause sound.
   - `onPlayResume(name, function)`
   <br>This event will be triggered whenever you resume sound.
   
------------

### Getting info about sound

------------
   - `soundExists(name)`<br>Will return true/false if sound exists
   
   - `isPaused(name)`<br>Will return true/false if song is paused
   
   - `isPlaying(name)`<br>Will return true/false if song is playing   
   
   - `isLooped(name)`<br>Will return true/false if sound is looped
   
   - `getDistance(name)`<br>Will return distance in Integer  
   
   - `getVolume(name)`<br>Will return current volume of music.   
   
   - `getPosition(name)`<br>Will return vector3
   
   - `isDynamic(name)` <br>Will return if sound is 3D or 2D (3D = true, 2D = false)
   
   - `getTimeStamp(name)`<br>returns current timestamp
     
   - `getMaxDuration(name)` <br>returns max duration of sound
   
   - `getLink(name)` <br>Will return url link 
   
   - `isPlayerInStreamerMode()` <br>will return if player got streamer mode enabled. 
   
   - `getAllAudioInfo()` <br>Will return array of all sound
   
   - `isPlayerCloseToAnySound()` <br>will return true if player is close to any sound.
   
   - `getInfo(name)` <br>Will return an array with info of the sound...
```LUA
{
   volume,          -- value from 0.0 to 1.0
   url ,            -- sound url
   id,              -- id 
   position,        -- will be nil if position isnt set.
   distance,        -- distance in integer
   playing,         -- true/false
   paused,          -- true/false
   loop,            -- true/false
   isDynamic,       -- true/false
   timeStamp,       -- returns current timestamp
   maxDuration,     -- returns max duration of sound
   destroyOnFinish, -- default value is true means after its finish it will destroy it self
}
```
------------

**1. Functions (Server side)**

------------

### Playing sound

------------
   - `PlayUrl(source, name, URL, volume, loop)`<br>Will play sound from URL (can be heard everywhere)
      
   - `PlayUrlPos(source, name, url, volume, Vector3 vec, loop)` <br>Will play sound from url at x,y,z location 
       
------------

### Manipulation with sound

------------
   - -1 for source work as well

   - `Position(source, name, Vector3 vec)`<br>Will update location of sound
   
   - `Distance(source, name, newDistance)`<br>Will set new playing distance from location
     
   - `Destroy(source, name)`<br>Will destroy sound
     
   - `Pause(source, name)`<br>Will pause sound
     
   - `Resume(source, name)`<br>Will resume sound       
     
   - `setVolume(source, name,volume)` volume is from 0.0 to 1.0<br>Will set a new value to volume. Should be used for non 3D sound
     
   - `setVolumeMax(source, name,volume)` volume is from 0.0 to 1.0<br>will set new value to max volume. Should be used only for 3D sound
   
   - `setTimeStamp(source ,name, time)` will set a new timestamp.
   <br>TIMESTAMP is in a seconds only !
------------

Showcase how it can stream sound at game

https://www.youtube.com/watch?v=zyZmF5bRSA4

https://www.youtube.com/watch?v=19Q2GVYElSE

Showcase what I did with my API

#These are just a showcase! I will not share them....

https://www.youtube.com/watch?v=OOf6PZFpfkI

https://www.youtube.com/watch?v=JRTVga_FwGw
