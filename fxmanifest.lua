fx_version 'adamant'
games { 'gta5' }

client_scripts {
	"config.lua",
	"timers.lua",
}

ui_page "html/index.html"

files {
	"Newtonsoft.Json.dll",
	
	"html/index.html",
	
	"html/scripts/config.js",
	"html/scripts/listener.js",
	"html/scripts/SoundPlayer.js",
	
	"html/sound/gta.mp3",
	"html/sound/radio.mp3",
	"html/sound/claps.mp3",
	"html/sound/naruto.mp3",
}

export{
	"Distance",
	"PlayUrl",
	"PlayUrlPos",
	"PlayPos",
	"Play",
	"Position",
	"Stop",
	"Resume",
	"Pause",
	"setVolume",
	"getVolume",
	"getInfo",
}