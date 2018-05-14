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

gcompute_instance appname do
  action :delete
  zone 'us-west1-a'
  project myproject
  credential 'mycred'
end

gcompute_address appname do
  action :delete
  region 'us-west1'
  project myproject
  credential 'mycred'
end
