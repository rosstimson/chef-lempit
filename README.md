# LEMPit cookbook

A cookbook which implements the wrapper/library pattern for the Opscode
Nginx, PHP, and MySQL cookbooks. It is intended to help PHP developers
to quickly and easily get a full LEMP (Linux, Nginx, MySQL, PHP-FPM)
stack up and running in Vagrant whilst delegating as much as possible to
the offical cookbooks.

## Requirements

To use this cookbook for the usage it is intended you will need:

Ruby and the Bundler Rubygem installed.
Vagrant - download from [vagrantup.com](http://vagrantup.com)
Vagrant-Omnibus and Vagrant-Berkshelf plugins, install with:

    vagrant plugin install vagrant-omnibus
    vagrant plugin install vagrant-berkshelf

The `example/Vagrantfile` also uses Vagrant-Cachier plugin to speed
things up, you may or may not want to use this.

    vagrant plugin install vagrant-cachier

## Usage

I've created an `./example` directory, those files should be placed
alongside your web project and then the following commands will spin up
an Ubuntu 12.04 instance, install Chef on the instance then pull in the
necessary cookbooks and provision:

    bundle install
    bundle exec berks install
    vagrant up

This may take some time on the first run as it downloads the Vagrant box if you
don't have it already.

You can now visit your web project at `localhost:8080`.

I have successfully tested popular CMSs (WordPress, Drupal, and MODX
using this cookbook. **Do not enable clean URLs without adding
appropriate rewrite rules to the Nginx config template
`template/default/lempit-site.erb`**

### MySQL

If you do not wish to login to the Vagrant box and interact with MySQL
directly you can use a GUI tool which supports connecting over SSH and
use the following settings:

    SSH Hostname:   127.0.0.1:2222
    SSH Username:   vagrant
    SSH Key File:   ~/.vagrant.d/insecure_private_key
    MySQL Hostname: 127.0.0.1
    MySQL Port:     3306
    MySQL Username: root
    MySQL Password: rootpass

## Platform

* Ubuntu 12.04

All platforms that the official cookbooks support should work with little
or no adjustments needed.  More OSs will be tested use kitchen-test
soon.

## Attributes

Since this cookbook just acts as a wrapper for the official Opscode
cookbooks please see their documentation for the available attributes:

[Nginx Cookbook](https://github.com/opscode-cookbooks/nginx)
[MySQL Cookbook](https://github.com/opscode-cookbooks/mysql)
[PHP Cookbook](https://github.com/opscode-cookbooks/php)

However the following attributes are set to override their defaults:

```ruby
set['mysql']['server_root_password']   = 'rootpass'
set['mysql']['server_repl_password']   = 'rootpass'
set['mysql']['server_debian_password'] = 'rootpass'
set['mysql']['bind_address'] = '0.0.0.0'

set['php']['fpm_user']   = 'vagrant'
set['php']['fpm_group']   = 'vagrant'
set['php']['directives'] = { 'date.timezone' => 'Europe/London' }
```

## Recipes

There is just one default recipe `lempit`, like I said the bulk of the
work is done by the official recipes.  :smile:

## Testing

There are some basic integration tests using test-kitchen.  If you want
to make changes or add support for another OS then you should look at
the tests.

    git clone https://github.com/rosstimson/chef-lempit
    cd chef-lempit
    bundle
    bundle exec kitchen list
    bundle exec kitchen test

## Author

Ross Timson: [ross@rosstimson.com](mailto:ross@rosstimson.com)
Twitter: [@rosstimson](https://twitter.com/rosstimson)

## License

Released under the [MIT License](http://www.opensource.org/licenses/MIT).
