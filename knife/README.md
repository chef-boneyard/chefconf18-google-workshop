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

There are only two settings in your knife.rb you'll "need" to set:

```ruby
knife[:gce_project] = 'my-test-project'
knife[:gce_zone]    = 'us-east1-b'
```

If you don't want to default to this you can also use the command line options:

```
knife google server list --gce-project my-test-project --gce-zone us-east1-b
```

Or for that matter take those other settings in the examples and put them in your
`knife.rb` so you don't have to keep typing them out.

## Examples

Note: If you want to see what --gce-images you can use, the `family` is what the `--gce-image`
takes as options.

```
gcloud compute images list
```

### Use `knife` to spin up an instance

Note: This will bootstrap the `chef-client` and connect the client to the chef-server if you have
one set up. There is your Day 1 provisioning!

```
knife google server create test-instance-1 --gce-image ubuntu-1604-lts  --gce-machine-type n1-standard-2 --gce-public-ip ephemeral --ssh-user jjasghar --identity-file /Users/jjasghar/.ssh/google_compute_engine
```

```
knife google server create test-instance-1 --gce-image centos-7 --gce-machine-type n1-standard-2 --gce-public-ip ephemeral --ssh-user jjasghar --identity-file /Users/jjasghar/.ssh/google_compute_engine
```

### Delete instance

```
knife google server delete test-instance-1 -P -y
```
