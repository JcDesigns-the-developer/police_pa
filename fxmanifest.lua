fx_version 'cerulean'
game 'gta5'

author 'Jc Designs'

description 'police pa ststem'

version '0.0.1'

lua54 'yes'

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

escrow_ignore {
'config.lua'
}

dependencies {
    'qb-core',
    'pma-voice',
    'xsound'
}