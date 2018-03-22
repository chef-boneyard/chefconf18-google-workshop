name 'vim'
maintainer 'JJ Asghar'
maintainer_email 'jj@chef.io'
license 'Apache 2.0'
description 'Installs vim'
long_description 'Installs vim.'
version '1.0.0'

%w(ubuntu debian redhat centos).each do |os|
  supports os
end
