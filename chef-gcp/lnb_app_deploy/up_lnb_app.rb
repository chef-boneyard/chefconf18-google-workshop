# ____ _  _ ____ ____ ____ ____ _  _ ____
# |    |__| |___ |___ |    |  | |\ | |___
# |___ |  | |___ |    |___ |__| | \| |
#

myproject = ENV['PROJECT'] || 'ENTER PROJECT NAME' # <----
appname = ENV['LNB_APP_NAME'] || 'my-lnb-app' # <----
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

# Google::Functions must be included at runtime to ensure that the
# gcompute_image_family function can be used in gcompute_disk blocks.
::Chef::Resource.send(:include, Google::Functions)

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

gcompute_machine_type 'n1-standard-1' do
  action :create
  zone 'us-west1-a'
  project myproject
  credential 'mycred'
end

gcompute_instance_template "#{appname}-tpl" do
  action :create
  it_label appname
  properties(
    machine_type: 'n1-standard-1',
    disks: [
      {
        # Tip: Auto delete will prevent disks from being left behind on
        # deletion.
        auto_delete: true,
        boot: true,
        initialize_params: {
          disk_size_gb: 100,
          source_image:
            gcompute_image_family('ubuntu-1604-lts', 'ubuntu-os-cloud')
        }
      }
    ],
    metadata: {
      'startup-script' =>
        File.read(File.join(__dir__, "../files/bootstrap2.sh"))
    },
    network_interfaces: [
      {
        network: 'default',
        access_configs: [
          {
            name: 'External NAT',
            network_tier: 'PREMIUM',
            type: 'ONE_TO_ONE_NAT'
          }
        ]
      }
    ],
    tags: {
      items: [
        appname,
        'http-server'
      ]
    }
  )
  project myproject
  credential 'mycred'
end

gcompute_http_health_check "#{appname}-hc" do
  action :create
  hhc_label appname
  healthy_threshold 10
  port 80
  timeout_sec 2
  unhealthy_threshold 5
  project myproject
  credential 'mycred'
end

gcompute_target_pool "#{appname}-tp" do
  action :create
  tp_label appname
  health_check "#{appname}-hc"
  region 'us-west1'
  project myproject
  credential 'mycred'
end

gcompute_instance_group_manager "#{appname}-vms" do
  action :create
  igm_label appname
  base_instance_name appname
  instance_template "#{appname}-tpl"
  target_size 3
  target_pools ["#{appname}-tp"]
  zone 'us-west1-a'
  project myproject
  credential 'mycred'
end

gcompute_address "#{appname}-lnb-ip" do
  action :create
  a_label appname
  region 'us-west1'
  project myproject
  credential 'mycred'
end

# TODO(nelsonjr): Remove 'http-server' tag from the template and change the
# comment below to reflect that we protected the machines.
#
# This firewall rule would be redundant as our service is already open to the
# Internet. However, for more locked down scenarios, e.g. when only traffic from
# your corporate network is allowed, you still want to allow the health checkers
# to reach your endpoints and assert health.
#
# This rule is also useful if you have a load balancer that has internet access,
# but you do not want direct connection from the Internet to the machine (this
# is preferred to shield the machines from the outside).
gcompute_firewall "#{appname}-fw" do
  action :create
  f_label appname
  allowed [
    {
      ip_protocol: 'tcp',
      ports: [ '80' ]
    }
  ]
  target_tags [
    appname
  ]
  source_ranges [
    '209.85.152.0/22',
    '209.85.204.0/22',
    '35.191.0.0/16',
    '130.211.0.0/22'
  ]
  project myproject
  credential 'mycred'
end
