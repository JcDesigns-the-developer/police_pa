fx_version 'cerulean'
game 'gta5'

lua54 'yes'

ui_page 'html/index.html'

shared_scripts {
    '@qb-core/shared/locale.lua',
    'config.lua'
}

client_scripts {
    '@PolyZone/client.lua',
    'client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

dependencies {
    'qb-core',
    'pma-voice',
    'xsound'
}