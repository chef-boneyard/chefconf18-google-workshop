# Managing Google Cloud Platform resources

Here is the notes for google's resource cookbooks to drive GCP.

We are going to just focus on Google compute, but there is a huge selection
of cookbooks to drive building up GCP. Check out
[this link](https://supermarket.chef.io/users/googlecloudplatform).

The Google Compute Engine cookbook is located on
[Chef Supermarket](https://supermarket.chef.io/cookbooks/google-gcompute).


## Step 1: Install Google Compute Engine cookbook

First thing first, you need to pull down the cookbooks:

    mkdir cookbooks
    cd cookbooks
    touch README.me
    git init
    git add .
    git commit -m "inital commit"
    knife supermarket install google-gcompute
    knife supermarket install google-gauth


## Step 2: Create and download a service account key

Next you need to create a service account `.json`. Make it administrator of the
services you will manage. For simplicity in this tutorial make it `Owner` or
`Editor`.

I would save it to your `~/` location, i.e. `gcp_creds.json`.

Tip: Protect this file as it contains the key to all your services:

    chmod 600 ~/gcp_creds.json


## Step 3: Create a cookbook to hold your recipes

You should have a cookbook to hold the recipes appropriate for your deployment.
In this tutorial we'll call ours `chef-gcp-workshop` but it can be anything you'd
like.

    chef generate cookbook ~/.chef/cookbooks/chef-gcp-workshop

You'll also need to make sure that your cookbook depends on the proper google cookbooks. Add the following lines to ~/.chef/cookbooks/chef-gcp-workshop/metadata.rb

    depends 'google-gauth'
    depends 'google-gcompute'


## Step 4: Create (or modify an existing) recipe for your deployment

Ok, go ahead and copy `one_machine.rb` and `one_machine_delete.rb` to your
cookbook (created in the previous step):

    cp one_machine.rb ~/.chef/cookbooks/chef-gcp-workshop/recipes
    cp one_machine_delete.rb ~/.chef/cookbooks/chef-gcp-workshop/recipes


## Step 5: Apply the recipe and spin up your machine

Run the command to spin up a machine:

    CRED_PATH=<path to service account file> PROJECT=<project name> chef-client -z -r "recipe[chef-gcp-workshop::one_machine]"

When it succeeds run the command to delete the machine:

    CRED_PATH=<path to service account file> PROJECT=<project name> chef-client -z -r "recipe[chef-gcp-workshop::one_machine_delete]"


## What's next?

Now you can programaticlly declare what you want with GCP with these cookbooks.
Go ahead and use the `one_machine` recipe and extend it to two machines of 4
gigs.
