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

Ok, now go into the vim-cookbook directory. Run the following commands:

```
# verify you have everything setup
kitchen list

# run in verification mode
kitchen verify -c 2

# clean up your machines
kitchen destroy

# run the one command!
kitchen test -c 2
```
