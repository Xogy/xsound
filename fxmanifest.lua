fx_version 'adamant'
games { 'gta5' }

client_scripts {
	"config.lua",
	"client/main.lua",
	"client/events.lua",

	"client/exports/info.lua",
	"client/exports/play.lua",
	"client/exports/manipulation.lua",
}

ui_page "html/index.html"

files {
	"html/index.html",
	
	"html/scripts/config.js",
	"html/scripts/listener.js",
	"html/scripts/SoundPlayer.js",
	"html/scripts/functions.js",
}

export{
	"PlayUrl", --
	"PlayUrlPos", --

	"Distance", --
	"Position", --
	"Destroy", --
	"Resume",--
	"Pause",--
	"setVolume",--
	"setVolumeMax",--

	"getVolume",--
	"getInfo",--
	"soundExists", --
	"isPaused",--
	"isPlaying",--
	"getDistance", --
	"isLooped", --
	"getPosition",--
	"getLink", --
}