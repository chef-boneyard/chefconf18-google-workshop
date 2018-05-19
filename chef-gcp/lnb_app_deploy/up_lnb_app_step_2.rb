# ____ _  _ ____ ____ ____ ____ _  _ ____
# |    |__| |___ |___ |    |  | |\ | |___
# |___ |  | |___ |    |___ |__| | \| |
#

include_recipe 'chef-gcp-workshop::up_lnb_app'

myproject = ENV['PROJECT'] || 'ENTER PROJECT NAME' # <----
appname = ENV['LNB_APP_NAME'] || 'my-lnb-app' # <----
cred_path = ENV['CRED_PATH'] || 'ENTER PATH TO YOUR CREDENTIAL HERE' # <----

# Google::Functions must be included at runtime to ensure that the
# gcompute_image_family function can be used in gcompute_disk blocks.
::Chef::Resource.send(:include, Google::Functions)

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
