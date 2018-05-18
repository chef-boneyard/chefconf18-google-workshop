# ____ _  _ ____ ____ ____ ____ _  _ ____
# |    |__| |___ |___ |    |  | |\ | |___
# |___ |  | |___ |    |___ |__| | \| |
#

myproject = 'ENTER PROJECT NAME' # <----
appname = 'my-lnb-app' # <----
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
    ]
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

cred = ::Google::Functions.gauth_credential_serviceaccount_for_function(
  cred_path,
  ['https://www.googleapis.com/auth/compute']
)

gcompute_forwarding_rule "#{appname}-fwd" do
  action :create
  fr_label appname
  ip_address gcompute_address_ip(appname, 'us-west1', myproject, cred)
  ip_protocol 'TCP'
  port_range '80'
  target "#{appname}-tp"
  region 'us-west1'
  project myproject
  credential 'mycred'
end
