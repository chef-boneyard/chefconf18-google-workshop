# ____ _  _ ____ ____ ____ ____ _  _ ____
# |    |__| |___ |___ |    |  | |\ | |___
# |___ |  | |___ |    |___ |__| | \| |
#

myproject = 'ENTER PROJECT NAME' # <----
appname = 'my-app' # <----
cred_path = 'ENTER PATH TO YOUR CREDENTIAL HERE' # <----

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

# Google::Functions must be included at runtime to ensure that the
# gcompute_image_family function can be used in gcompute_disk blocks.
::Chef::Resource.send(:include, Google::Functions)

gcompute_disk "#{appname}-os-1" do
  action :create
  source_image gcompute_image_family('ubuntu-1604-lts', 'ubuntu-os-cloud')
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

gcompute_address appname do
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

gcompute_instance appname do
  action :create
  machine_type 'n1-standard-8'
  disks [{
    boot: true,
    auto_delete: true,
    source: "#{appname}-os-1"
  }]
  network_interfaces [{
    network: 'default',
    access_configs: [{
      name: 'External NAT',
      nat_ip: appname,
      type: 'ONE_TO_ONE_NAT'
    }]
  }]
  zone 'us-west1-a'
  project myproject
  credential 'mycred'
  metadata ({
    'startup-script' => File.read(File.join(__dir__, "../files/bootstrap.sh"))
  })
  tags ({
    # TODO(nelsonjr): Add encoder to remove "items" from tags array
    # https://github.com/GoogleCloudPlatform/magic-modules/issues/179
    items: [
      'http-server',
    ]
 })
end
