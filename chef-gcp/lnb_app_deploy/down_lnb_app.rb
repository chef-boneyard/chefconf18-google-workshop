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

gcompute_region 'us-west1' do
  action :create
  project myproject
  credential 'mycred'
end

gcompute_zone 'us-west1-a' do
  action :create
  project myproject
  credential 'mycred'
end

gcompute_backend_service appname do
  action :delete
  project myproject
  credential 'mycred'
end

gcompute_instance_group_manager appname do
  action :delete
  zone 'us-west1-a'
  project myproject
  credential 'mycred'
end

gcompute_instance_group_manager appname do
  action :delete
  zone 'us-west1-a'
  project myproject
  credential 'mycred'
end

gcompute_instance_template appname do
  action :delete
  project myproject
  credential 'mycred'
end

gcompute_forwarding_rule appname do
  action :delete
  region 'us-west1'
  project myproject
  credential 'mycred'
end

gcompute_target_pool appname do
  action :delete
  region 'us-west1'
  project myproject
  credential 'mycred'
end

gcompute_http_health_check appname do
  action :delete
  project myproject
  credential 'mycred'
end

gcompute_address appname do
  action :delete
  region 'us-west1'
  project myproject
  credential 'mycred'
end

gcompute_firewall appname do
  action :delete
  project myproject
  credential 'mycred'
end
