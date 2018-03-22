raise "Missing parameter 'CRED_PATH'. Please read docs at #{__FILE__}" \
  unless ENV.key?('CRED_PATH')

myproject = 'ENTER PROJECT NAME' # <----
instancename = 'test-machine' # <----

gauth_credential 'mycred' do
  action :serviceaccount
  path ENV['CRED_PATH'] # e.g. '/path/to/my_account.json'
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
