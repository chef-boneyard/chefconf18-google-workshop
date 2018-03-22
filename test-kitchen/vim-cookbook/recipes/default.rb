#
# Cookbook:: vim
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.


# run the correct linux bootstrap recipe
case node['platform_family']
when 'debian'
  package 'vim'
when 'rhel'
  package 'vim-enhanced'
end
