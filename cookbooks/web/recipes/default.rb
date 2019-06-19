package "nginx";
package "nginx-extras";
package "mysql-client"
package "php-imagick";
package "php-soap";
package "php-xml";
package "php7.2-cli";
package "php7.2-curl";
package "php7.2-fpm";
package "php7.2-gd";
package "php7.2-intl";
package "php7.2-mbstring";
package "php7.2-mysql";
package "php7.2-opcache";
package "php7.2-xml";
package "php7.2-zip";

# Delete default configuration files
file_array = ['/etc/nginx/sites-enables/default',
              '/etc/nginx/sites-available/default']

file_array.each do |this_file|
  file this_file do
    action :delete
  end
end

# Install aws-elasticache plugin
cookbook_file '/usr/lib/php/20170718/amazon-elasticache-cluster-client.so' do
  source 'amazon-elasticache-cluster-client.so'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

file '/etc/php/7.2/mods-available/aws-memcache.ini' do
  content 'extension=amazon-elasticache-cluster-client.so'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

execute 'enable aws-memcache module' do
  command 'phpenmod aws-memcache'
  action :run
end

service "php7.2-fpm" do
  action [:stop, :disable]
end

service "nginx" do
  action [:stop, :disable]
end