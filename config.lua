config = {}

-- will show debug in game ( can be turn on in prod, the debug will allow access to the command /showsounds )
config.debug = false

-- How much ofter the player position is updated ?
config.RefreshTime = 300

-- YouTube Data API v3 key (optional). Leave EMPTY to disable.
-- Reading a video's length used to spawn a SECOND full hidden YouTube player per play just to
-- read its duration. CEF never frees the native/GPU memory of a YouTube embed, so every play
-- permanently grew the FiveM process RAM. With a key, duration is fetched over the lightweight
-- Data API (no video pipeline). With no key, duration is skipped (end-detection still works via
-- the player state, only the timestamp/length HUD value is unknown).
-- Get a free key: https://console.cloud.google.com -> enable "YouTube Data API v3" -> Credentials.
config.youtubeApiKey = ""

-- Reclaim YouTube memory when idle (seconds, 0 = disable).
-- CEF does not return a YouTube embed's native/GPU memory until the whole browser (DUI) is
-- destroyed. When NO sound has been playing for this long, the audio DUI is recycled, dropping
-- the FiveM process RAM back to baseline. Recycling happens ONLY while nothing is playing, so it
-- never interrupts music. Raise it if your server almost always has music playing.
config.idleDuiRecycleSec = 20

-- Max simultaneous YouTube player instances. Players are pooled and reused across songs via
-- loadVideoById, so back-to-back playback (a jukebox) does not keep spawning new players that
-- CEF cannot free. Total YouTube memory is bounded by this number regardless of how many songs
-- are played. Raise only if you genuinely need more than this many DIFFERENT YouTube sounds at once.
config.youtubePoolMax = 6

-- Anti-abuse for client-triggerable sound events (interact-sound emulator + crewphone).
-- Legit calls pass through unchanged; abusers are rate-limited or rejected.
config.security = {
    enabled        = true,
    -- max trigger events per player per window (ms)
    rate           = { count = 5, windowMs = 10000 },
    -- volume is clamped into [0, maxVolume]
    maxVolume      = 1.0,
    -- allowed file extensions for emulator sound files
    allowedExt     = { "ogg", "mp3", "wav" },
    -- allowed hosts for crewphone remote links
    allowedDomains = { "youtube.com", "youtu.be" },
    -- ACE permission required to broadcast to everyone. Empty = disabled (default, drop-in safe)
    broadcastAce   = "",
    -- print a one-line warning when an event is rejected
    log            = true,
}

-- default sound format for interact
config.interact_sound_file = "ogg"

-- is emulator enabled ?
config.interact_sound_enable = false

-- how much close player has to be to the sound before starting updating position ?
config.distanceBeforeUpdatingPos = 40

-- Message list
config.Messages = {
    ["streamer_on"]  = "Streamer mode is on. From now you will not hear any music/sound.",
    ["streamer_off"] = "Streamer mode is off. From now you will be able to listen to music that players might play.",

    ["no_permission"] = "You cant use this command, you dont have permissions for it!",
}

-- Addon list
-- True/False enabled/disabled
config.AddonList = {
    crewPhone = false,
}