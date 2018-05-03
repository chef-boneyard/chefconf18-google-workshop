myproject = ENV['PROJECT'] || 'ENTER PROJECT NAME' # <----
instancename = ENV['INSTANCE'] || 'test-machine' # <----
cred_path = ENV['CRED_PATH'] || 'ENTER PATH TO YOUR CREDENTIAL HERE' # <----

gauth_credential 'mycred' do
  action :serviceaccount
  path cred_path
  scopes [
    'https://www.googleapis.com/auth/compute'
  ]
end

gcompute_zone 'us-west1-a' do
  action :create
  project myproject
  credential 'mycred'
end

gcompute_disk 'instance-test-os-1' do
  action :create
  source_image 'projects/ubuntu-os-cloud/global/images/family/ubuntu-1604-lts'
  zone 'us-west1-a'
  project myproject
  credential 'mycred'
end

gcompute_network 'default' do
  action :create
  project myproject
  credential 'mycred'
end

gcompute_region 'us-west1' do
  action :create
  project myproject
  credential 'mycred'
end

gcompute_address 'instance-test-ip' do
  action :create
  region 'us-west1'
  project myproject
  credential 'mycred'
end

gcompute_machine_type 'n1-standard-8' do
  action :create
  zone 'us-west1-a'
  project myproject
  credential 'mycred'
end

gcompute_instance instancename do
  action :create
  machine_type 'n1-standard-8'
  disks [
    {
      boot: true,
      auto_delete: true,
      source: 'instance-test-os-1'
    }
  ]
  network_interfaces [
    {
      network: 'default',
      access_configs: [
        {
          name: 'External NAT',
          nat_ip: 'instance-test-ip',
          type: 'ONE_TO_ONE_NAT'
        }
      ]
    }
  ]
  zone 'us-west1-a'
  project myproject
  credential 'mycred'
  # metadata ({
  #             items: [
  #               { key: 'startup-script-url',
  #                 value: 'https://storage.googleapis.com/jjasghar/bootstrap.sh'
  #               }
  #             ]
  #           })
  tags ({
          items: [
            'http-server',
            'https-server'
          ]
        })
end
