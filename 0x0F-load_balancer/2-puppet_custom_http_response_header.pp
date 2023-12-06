# Installs a Nginx server with custome HTTP header

exec {'update':
  command  => 'sudo apt-get -y update',
}

# Install Nginx package
package { 'nginx':
	ensure => 'installed',
	require => Exec['update']
}

# Create directories and files
file { '/etc/nginx/html':
  ensure => directory,
}

file { '/etc/nginx/html/index.html':
  ensure  => file,
  content => 'Hello World!',
}

file { '/etc/nginx/html/404.html':
  ensure  => file,
  content => "Ceci n'est pas une page",
}

# Configure Nginx
file { '/etc/nginx/sites-available/default':
  ensure  => file,
  content => "\
server {
    add_header X-Served-By $(hostname);
    listen 80;
    listen [::]:80 default_server;
    root   /etc/nginx/html;
    index  index.html index.htm;

    location /redirect_me {
        return 301 https://www.youtube.com/watch?v=QH2-TGUlwu4;
    }

    error_page 404 /404.html;
    location = /404.html {
        root /etc/nginx/html;
        internal;
    }
}",
  require => Package['nginx'],
}

# Restart Nginx service
service { 'nginx':
  ensure     => running,
  enable     => true,
  subscribe  => File['/etc/nginx/sites-available/default'],
  require    => Package['nginx'],
}
