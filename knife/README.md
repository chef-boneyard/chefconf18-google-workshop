# knife-google

`knife google` is the main bootstrapping method between Chef and GCP. First you need it installed.

## Setup

If you have the ChefDK installed, you can do the following:

```
chef gem install knife-google
```

Otherwise you'll need to install ruby and/or chef and do:

```
gem install knife-google
```

## knife.rb

There are only two settings in your knife.rb you'll need to set:

```ruby
knife[:gce_project] = 'my-test-project'
knife[:gce_zone]    = 'us-east1-b'
```

If you don't want to default to this you can also use the command line options:

```
knife google server list --gce-project my-test-project --gce-zone us-east1-b
```

## Examples

```
# If you want to see what --gce-images you can use
gcloud compute images list

# Spins up a machine 2 gig machine
knife google server create test-instance-1 --gce-image ubuntu-1604-xenial-v20180306 --gce-machine-type n1-standard-2 --gce-public-ip ephemeral --ssh-user jjasghar --identity-file /Users/jjasghar/.ssh/google_compute_engine

knife google server create test-instance-1 --gce-image centos-7-v20180314 --gce-machine-type n1-standard-2 --gce-public-ip ephemeral --ssh-user jjasghar --identity-file /Users/jjasghar/.ssh/google_compute_engine
```
