fx_version 'bodacious'
game 'gta5'

version '1.1'

ui_page 'client/html/UI.html'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
    'server/ui.lua',
    'server/garage.lua',
    'config.lua'
    
}

client_scripts {
    'client/ui.lua',
    'client/garage.lua',
	'config.lua'
}

files {
    'client/html/UI.html',
    'client/html/script.js',
    'client/html/style.css',
    'client/html/media/garagelogo.png'
    
}