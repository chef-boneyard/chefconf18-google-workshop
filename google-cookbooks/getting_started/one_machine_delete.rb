myproject = 'ENTER PROJECT NAME' # <----
instancename = 'test-machine' # <----
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

gcompute_instance instancename do
  action :delete
  zone 'us-west1-a'
  project myproject
  credential 'mycred'
end
