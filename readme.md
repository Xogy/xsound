#a small library for Fivem to play better sounds at game.

### SoundSystem functions

**1. Functions (client side)**
------------
   - PLayUrl(name, url, volume)
     <br>Will play sound from url
      
   - PlayUrlPos(name, url, volume, Vector3 vec)
     <br>Will play sound from url at x,y,z location 
     
   - PLay(name, url, volume)
     <br>Will play sound that is defined in html/scripts/config.js
      
   - PlayPos(name, url, volume, Vector3 vec)
     <br>Will play sound that is defined in html/scripts/config.js at x,y,z location      

   - Position(name, Vector3 vec)
     <br>Will update location of sound
     
   - Stop(name)
     <br>Will stop completly sound
     
   - Pause(name)
     <br>Will pause sound
     
   - Resume(name)
     <br>Will resume sound       
     
   - setVolume(name,volume) volume is from 0.0 to 1.0
     <br>Will set a new value to volume.
     
   - setVolumeMax(name,volume) volume is from 0.0 to 1.0
     <br>will set new value to max volume.  
 
   - getVolume(name)
     <br>Will return current volume of music.
     
   - getInfo(name) 
      <br>Will return an array with info of song..
      <br>it will return 
```LUA
{
	volume,
	url,
	id,
	position, -- will be nil if position isnt set.
	distance,
	playing,
}
```
------------

 **Example client**       
 
```LUA
xSound = exports.xSound
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
xSound = exports.xSound
Citizen.CreateThread(function()
    local pos = GetEntityCoords(PlayerPedId())
    xSound:PlayUrlPos("name","https://www.youtube.com/watch?v=dQw4w9WgXcQ",1,pos)
    --some links will not work cause to copyright or autor did not allowed to play video from iframe.
    xSound:Distance("name",100)
    
    Citizen.Wait(1000*30)
    xSound:Stop("name")
end)
``` 

Some video preview how you can use it.

https://www.youtube.com/watch?v=zyZmF5bRSA4

https://www.youtube.com/watch?v=19Q2GVYElSE
