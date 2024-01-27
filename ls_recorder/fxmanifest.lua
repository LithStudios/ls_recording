fx_version 'cerulean'
games      { 'gta5' }

author 'Lith Studios | Swizz'
description 'Recording Script by Lith Studios'
version '1.0.0'

ui_page 'nui/index.html'

--
-- Files
--

files {
    'nui/img/*.svg',
    'nui/*.css',
    'nui/index.html',
    'nui/script.js',
}
--
-- Client
--

client_scripts {
    'config.lua',
    'client/settings.lua',
    'client/client.lua',
    'client/editable.lua',
    'client/cache.lua'
}
