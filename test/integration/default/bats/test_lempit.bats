# Basic test to make sure LEMP stack is installed and running.

###############################################################################
# MySQL tests

@test "mysql is installed and in the path" {
  which mysql
}

@test "mysql config file is in place" {
  ls /etc/mysql/my.cnf
}

@test "mysql server is running" {
  run service mysql status
  [ "$status" -eq 0 ]
  echo "$output" | grep -Eq "mysql start/running, process [0-9]*$"
}

###############################################################################
# Nginx tests

@test "nginx is installed and in the path" {
  which nginx
}

@test "main nginx config file is in place" {
  ls /etc/nginx/nginx.conf
}

@test "nginx server is running" {
  run service nginx status
  [ "$status" -eq 0 ]
  echo "$output" | grep -Eq '* nginx is running'
}

###############################################################################
# PHP tests

@test "php is installed and in path" {
  which php
}

@test "main php.ini config file is in place" {
  ls /etc/php5/cli/php.ini
}

# This is important as extra directives passed by Chef get added into
# /etc/php5/cli/php.ini which is not picked up if running PHP-FPM.
@test "php.ini is symlinked into conf.d" {
  [ -h "/etc/php5/conf.d/cli.ini" ]
}

@test "php-fpm service is running" {
  run service php5-fpm status
  [ "$status" -eq 0 ]
  echo "$output" | grep -Eq '* php5-fpm is running'
}

# This is important PHP must run as vagrant user to have access to web app at
# /vagrant
@test "php-fpm running as vagrant user" {
  run ps -u vagrant -o command=
  [ "$status" -eq 0 ]
  echo "$output" | uniq | grep -Eq 'php-fpm: pool www'
}
