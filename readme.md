#Improved audio library for FiveM

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
   
   - isLooped(name)<br>Will return true/false if sound is looped
   
   - getDistance(name)<br>Will return distance in Integer  
   
   - getVolume(name)<br>Will return current volume of music.   
   
   - getPosition(name) <br>Will return vector3
   
   - getLink(name) <br>Will return url link 
   
   - getInfo(name) <br>Will return an array with info of song..<br>it will return    
```LUA
{
volume,   -- value from 0.0 to 1.0
url ,     -- sound url
id,       -- id 
position, -- will be nil if position isnt set.
distance, -- distance in integer
playing,  -- true/false
paused,   -- true/false
loop,     -- true/false
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
    xSound:Destroy("name")
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
    xSound:Destroy("name")
end)
``` 

Showcase how it can stream sound at game

https://www.youtube.com/watch?v=zyZmF5bRSA4

https://www.youtube.com/watch?v=19Q2GVYElSE

Showcase what i did with my api

#These are just a showcase! i will not share them....

https://www.youtube.com/watch?v=OOf6PZFpfkI

https://www.youtube.com/watch?v=JRTVga_FwGw
