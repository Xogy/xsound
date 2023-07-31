fx_version 'cerulean'
games { 'gta5', 'rdr3' }

rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

--[[ Resource Information ]]--
name         'xsound'
version      '1.4.3'

client_scripts {
	"config.lua",
	"client/main.lua",
	"client/events.lua",
	"client/commands.lua",

	"client/exports/info.lua",
	"client/exports/play.lua",
	"client/exports/manipulation.lua",
	"client/exports/events.lua",
	"client/effects/main.lua",

	"client/emulator/interact_sound/client.lua",

	"addon/**/client/*.lua",
}

server_scripts {
	"config.lua",
	"server/exports/play.lua",
	"server/exports/manipulation.lua",

	"server/emulator/interact_sound/server.lua",

	"addon/**/server/*.lua",
}

ui_page "html/index.html"

files {
	"html/index.html",

	"html/scripts/listener.js",
	"html/scripts/SoundPlayer.js",
	"html/scripts/functions.js",

	"html/sounds/*.ogg",
	"html/sounds/*.mp3",
}
