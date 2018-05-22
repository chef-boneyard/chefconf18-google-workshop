# test-kitchen

These are the notes to get `kitchen-google` working with GCP.

## Setup

Install the gem with:

```
gem install kitchen-google
```

Or, even better, if you're using the ChefDK:

```
chef gem install kitchen-google
```

## Example

- [`kitchen.yml`](./kitchen.example.yml) - A generic kitchen.yml for `gcp`
- [`vim-cookbook`](./vim-cookbook) - A cookbook that is mostly setup for testing.

Take a look at the `kitchen.example.yml` here, you'll see that it's pretty standard when it comes to kitchen.

If you're using Cloud Shell, run `gcloud config list` to get the email address for kitchen.yml

Ok, now go into the vim-cookbook directory. Run the following commands:

### Verify you have everything setup

```
kitchen list
```

### Run in verification mode

```
kitchen verify -c 2
```

### Clean up your machines

```
kitchen destroy
```

### Run the one command!
```
kitchen test -c 2
```
