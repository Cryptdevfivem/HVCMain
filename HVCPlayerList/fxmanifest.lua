fx_version 'cerulean'

game 'gta5'

lua54 'yes'
use_fxv2_oal 'yes'

description 'HVCPlayerList'

version '1.0.0'

client_scripts {
    'config.lua',
    'client.lua'
}

server_scripts{
    "@hvc/lib/utils.lua",
    'server/classes/player.lua',
    'server/server.lua'
}

ui_page 'html/ui.html'

files {
    'html/ui.html',
    'html/fonts/*.ttf',
    'html/css/*.css',
    'html/img/*.png',
    'html/js/*.js'
} 