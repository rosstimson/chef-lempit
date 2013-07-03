name             	'lempit'
maintainer       	'Ross Timson'
maintainer_email 	'ross@rosstimson.com'
license          	'MIT'
description      	'Installs a LEMP stack for local development of PHP projects.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          	'0.1.0'

depends						'mysql'
depends						'nginx'
depends						'php'

%w{ ubuntu }.each do |os|
    supports os
end
