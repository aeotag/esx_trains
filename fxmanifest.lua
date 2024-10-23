fx_version 'cerulean'
game 'gta5'

author 'Bolt'
description 'Automated Train System for ESX Framework'
version '1.0.0'

shared_scripts {
    '@es_extended/imports.lua',
    'config.lua'
}

client_scripts {
    'client/main.lua',
    'client/display.lua',
    'client/tickets.lua',
    'client/audio.lua',
    'client/police.lua',
    'client/npc.lua',
    'client/doors.lua'
}

server_scripts {
    'server/main.lua',
    'server/tickets.lua'
}