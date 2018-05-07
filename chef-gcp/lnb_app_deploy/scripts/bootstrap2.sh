#!/bin/bash

info() {
  if [[ $TERM =~ color ]]; then
    echo -e "\e[92mINFO:\e[0m $*"
  else
    echo "INFO: $*"
  fi
  logger -t bootstrapper "INFO: $*"
}

action() {
  if [[ $TERM =~ color ]]; then
    echo -e "\e[93mACTION:\e[0m $*"
  else
    echo "ACTION: $*"
  fi
  logger -t bootstrapper "ACTION: $*"
}

info 'Starting bootstrap'

if [[ -e '/usr/bin/chef-client' ]]; then
  info 'Chef already installed. Skipping installation.'
else
  action 'Installing Chef client'
  curl -L https://www.opscode.com/chef/install.sh | sudo bash
fi

if [[ -e '/usr/bin/chef' ]]; then
  info 'Chef Development Kit already installed. Skipping installation.'
else
  action 'Installing Chef Development Kit'
  curl -O 'https://packages.chef.io/files/stable/chefdk/2.5.3/ubuntu/16.04/chefdk_2.5.3-1_amd64.deb'
  dpkg -i 'chefdk_2.5.3-1_amd64.deb'
fi

if [[ -d /cookbooks ]]; then
  info 'Cookbooks already created. Skipping initialization.'
else
  action 'Creating Chef cookbooks'
  mkdir /cookbooks
  cd /cookbooks
  git init
  git add .
  git commit -m "inital commit"
fi

if [[ -d /cookbooks/setup ]]; then
  info 'Infrastructure cookbook already present.'
else
  action 'Generating Chef cookbook setup'
  chef generate cookbook /cookbooks/setup
  rm /cookbooks/setup/recipes/default.rb
fi

if [[ -f /cookbooks/setup/recipes/default.rb ]]; then
  info 'Application startup script already present.'
else
  action 'Generating Application startup script'
  cat <<EOF >/cookbooks/setup/recipes/default.rb
package 'nginx' do
  action :install
end

service 'nginx' do
  action [ :enable, :start ]
end

file '/var/www/html/index.nginx-debian.html' do
  action :delete
end

cookbook_file '/var/www/html/index.html' do
  source 'index.html'
  mode '0644'
end
EOF
fi

if [[ -f /cookbooks/setup/files/default/index.html ]]; then
  info 'Appliction home page already present.'
else
  action 'Generating Application home page'
  mkdir -p /cookbooks/setup/files/default
  cat <<EOF >/cookbooks/setup/files/default/index.html
<html>
<style>BODY { font-family: Verdana; text-align: center; }</style>
<body>
  <h1>Welcome from ChefConf Workshop</h1>
  <p>This is our multi instance, load balanced application</p>
  <p>I'm server <font size='+2'><b><code>${HOSTNAME}</code></b></font></p>
</body>
</html>
EOF
fi

action 'Converging state with Chef'
chef-client -z --runlist setup

info 'Bootstrap complete'
