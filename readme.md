#a small library for Fivem to play better sounds at game.

### SoundSystem functions

**1. Functions (client side)**
------------

##### Playing sound
------------
   - PlayUrl(name, url, volume)<br>Will play sound from url (can be heared everywhere)
      
   - PlayUrlPos(name, url, volume, Vector3 vec) <br>Will play sound from url at x,y,z location 
------------
##### Manipulation with sound
------------
   - Position(name, Vector3 vec)<br>Will update location of sound
   
   - Distance(name, newDistance)<br>Will set new playing distance from location
     
   - Destroy(name)<br>Will destroy sound
     
   - Pause(name)<br>Will pause sound
     
   - Resume(name)<br>Will resume sound       
     
   - setVolume(name,volume) volume is from 0.0 to 1.0<br>Will set a new value to volume.
     
   - setVolumeMax(name,volume) volume is from 0.0 to 1.0<br>will set new value to max volume.  
------------
 ##### Getting info about sound
------------
   - soundExists(name)<br>Will return true/false if sound exists
   
   - isPaused(name)<br>Will return true/false if song is paused
   
   - isPlaying(name)<br>Will return true/false if song is playing   
   
   - getDistance(name)<br>Will return distance in Integer 
   
   - isLooped(name)<br>Will return distance in Integer    
   
   - getVolume(name)<br>Will return current volume of music.
     
   - getInfo(name) <br>Will return an array with info of song..<br>it will return 
   
   - getPosition(name) <br>Will return vector3
   
   - getLink(name) <br>Will return url link 
```LUA
{
	volume,
    url ,
    id,
    position, -- will be nil if position isnt set.
    distance,
    playing,
    paused,
    loop,
}
```
------------

 **Example client**       
 
```LUA
xSound = exports.xsound
Citizen.CreateThread(function()
    local pos = GetEntityCoords(PlayerPedId())
    xSound:PlayUrlPos("name","http://relisoft.cz/assets/brainleft.mp3",1,pos)
    xSound:Distance("name",100)
    
    Citizen.Wait(1000*30)
    xSound:Stop("name")
end)
``` 

 **How to play youtube link**    
```LUA
xSound = exports.xsound
Citizen.CreateThread(function()
    local pos = GetEntityCoords(PlayerPedId())
    xSound:PlayUrlPos("name","https://www.youtube.com/watch?v=6Dh-RL__uN4",1,pos)
    --some links will not work cause to copyright or autor did not allowed to play video from iframe.
    xSound:Distance("name",100)
    
    Citizen.Wait(1000*30)
    xSound:Stop("name")
end)
``` 

Some video preview how you can use it.

https://www.youtube.com/watch?v=zyZmF5bRSA4

https://www.youtube.com/watch?v=19Q2GVYElSE
