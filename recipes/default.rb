include_recipe 'mysql::server'
include_recipe 'mysql::client'
include_recipe 'nginx::repo'
include_recipe 'nginx::default'
include_recipe 'php'

%w{ curl php5-fpm php5-curl php5-gd php5-gmp php5-imagick php5-xdebug 
  php5-mcrypt php5-xmlrpc php5-xsl php5-sqlite php5-mysql php5-mysqlnd
  php5-pgsql }.each do |pkg|
  package pkg do
    action :install
  end
end

service 'php5-fpm' do
  supports restart: true, reload: true
  action :enable
end

# Needed so PHP-FPM will run as vagrant user so that it has permissions
# on the web app at /vagrant
template '/etc/php5/fpm/pool.d/www.conf' do
  source 'lempit-fpm-pool.erb'
  mode 0644
  owner 'root'
  group 'root'
  notifies :restart, 'service[php5-fpm]'
end

# Symlink the main PHP config into /etc/php5/conf.d/ so that PHP-FPM picks up
# changes passed to Chef as an attribute hash, in this case the default TZ.
# NOTE: Reload just doesn't seem to cut it here for some strange reason.
link '/etc/php5/conf.d/cli.ini' do
  to '/etc/php5/cli/php.ini'
  notifies :restart, 'service[php5-fpm]'
end

chef_gem 'chef-rewind'
require 'chef/rewind'

# Comment out /etc/nginx/conf.d/*.conf so that Nginx does not slurp all
# localhost connections and display it's default Welcome page.
rewind template: "nginx.conf" do
  source 'lempit-nginx.conf.erb'
  cookbook_name 'lempit'
end

# Replace the default site with one that has a root of /vagrant, serves on
# localhost, and is PHP-FPM enabled.
rewind template: "#{node['nginx']['dir']}/sites-available/default" do
  source 'lempit-site.erb'
  cookbook_name 'lempit'
end
