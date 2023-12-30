fx_version 'cerulean'



game 'gta5'

lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client.lua',
    'pay.lua',
}

depedencies  {
    'ox_target',
    'oxmysql',
    'ox_lib'
}


server_scripts { 
    'server.lua',
    '@oxmysql/lib/MySQL.lua',
}