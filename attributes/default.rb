set['mysql']['server_root_password']   = 'rootpass'
set['mysql']['server_repl_password']   = 'rootpass'
set['mysql']['server_debian_password'] = 'rootpass'
set['mysql']['bind_address']           = '0.0.0.0'

set['php']['fpm_user']   = 'vagrant'
set['php']['fpm_group']   = 'vagrant'
set['php']['directives'] = { 'date.timezone' => 'Europe/London' }
