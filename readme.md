#Improved audio library for FiveM

Can work with api interact sound<br>
Just make sure you take all sounds from interact<br>
sound and move them to xsound/html/sounds

Thanks to<br>
https://github.com/plunkettscott<br>
for awesome api<br>
https://github.com/plunkettscott/interact-sound<br>

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
     
   - setVolume(name,volume) volume is from 0.0 to 1.0<br>Will set a new value to volume. Should be used for non 3D sound
     
   - setVolumeMax(name,volume) volume is from 0.0 to 1.0<br>will set new value to max volume. Should be used only for 3D sound
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
   
   - isDynamic(name) <br>Will return if sound is 3D or 2D (3D = true, 2D = false)
   
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
isDynamic,-- true/false
}
```
------------
**1. Functions (Server side)**
------------

##### Playing sound
------------
   - PlayUrl(source, name, url, volume)<br>Will play sound from url (can be heared everywhere)
      
   - PlayUrlPos(source, name, url, volume, Vector3 vec) <br>Will play sound from url at x,y,z location 
------------
##### Manipulation with sound
------------
   - -1 for source work aswell

   - Position(source, name, Vector3 vec)<br>Will update location of sound
   
   - Distance(source, name, newDistance)<br>Will set new playing distance from location
     
   - Destroy(source, name)<br>Will destroy sound
     
   - Pause(source, name)<br>Will pause sound
     
   - Resume(source, name)<br>Will resume sound       
     
   - setVolume(source, name,volume) volume is from 0.0 to 1.0<br>Will set a new value to volume. Should be used for non 3D sound
     
   - setVolumeMax(source, name,volume) volume is from 0.0 to 1.0<br>will set new value to max volume. Should be used only for 3D sound
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

 **How to be followed by the sound**    
 Client:
```LUA
xSound = exports.xsound

local musicId
local playing = false
Citizen.CreateThread(function()
    Citizen.Wait(1000)
    musicId = "music_id_" .. PlayerPedId()
    local pos
    while true do
        Citizen.Wait(100)
        if xSound:soundExists(musicId) and playing then
            if xSound:isPlaying(musicId) then
                pos = GetEntityCoords(PlayerPedId())
                TriggerServerEvent("myevent:soundStatus", "position", musicId, { position = pos })
            else
                Citizen.Wait(1000)
            end
        else
            Citizen.Wait(1000)
        end
    end
end)

RegisterCommand("playmusic", function(source, args, rawCommand)
    local pos = GetEntityCoords(PlayerPedId())
    playing = true
    TriggerServerEvent("myevent:soundStatus", "play", musicId, { position = pos, link = "https://www.youtube.com/watch?v=6Dh-RL__uN4" })
end, false)

RegisterNetEvent("myevent:soundStatus")
AddEventHandler("myevent:soundStatus", function(type, musicId, data)
    if type == "position" then
        if xSound:soundExists(musicId) then
            xSound:Position(musicId, data.position)
        end
    end

    if type == "play" then
        xSound:PlayUrlPos(musicId, data.link, 1, data.position)
        xSound:Distance(musicId, 20)
    end
end)
``` 
 Server:
```LUA
RegisterNetEvent("myevent:soundStatus")
AddEventHandler("myevent:soundStatus", function(type, musicId, data)
    TriggerClientEvent("myevent:soundStatus", -1, type, musicId, data)
end)
``` 
Showcase how it can stream sound at game

https://www.youtube.com/watch?v=zyZmF5bRSA4

https://www.youtube.com/watch?v=19Q2GVYElSE

Showcase what i did with my api

#These are just a showcase! i will not share them....

https://www.youtube.com/watch?v=OOf6PZFpfkI

https://www.youtube.com/watch?v=JRTVga_FwGw
