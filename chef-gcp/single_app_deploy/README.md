# Deploying a Single Instance Application to Google Cloud Platform

Here is the notes for google's resource cookbooks to create a single instance application.

> You can skip steps 1 through 3 if you already performed them.


## Step 1: Install Google Compute Engine cookbook

First thing first, you need to pull down the cookbooks:

    mkdir cookbooks
    cd cookbooks
    git init
    git add .
    git commit -m "inital commit"
    knife supermarket install google-cloud


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

    chef generate cookbook ~/cookbooks/chef-gcp-workshop


## Step 4: Create (or modify an existing) recipe for your deployment

Ok, go ahead and edit the `deploy_app.rb` and `down_app.rb` with your
settings and move them to your cookbook (created in the previous step):

    vi deploy_app.rb
    vi down_app.rb
    mv deploy_app.rb ~/cookbooks/chef-gcp-workshop/recipes
    mv down_app.rb ~/cookbooks/chef-gcp-workshop/recipes


## Step 5: Apply the recipe and spin up your machine

Run the command to spin up a machine:

    chef-client -z -r "recipe[chef-gcp-workshop::deploy_app]"

When it succeeds run the command to delete the machine:

    chef-client -z -r "recipe[chef-gcp-workshop::down_app]"


## Step 6: Verify you web application is serving traffic

Visit the external IP address of the machine created. You can retrieve the 
IP address in the Developer Console or by running
`gcloud compute instances list`.

# Step 7: Deleting the deployment

Simply run the `down_app` recipe:

```
chef-client -z --runlist 'recipe[chef-gcp-workshop::down_app]'
```


## What's next?

Next you can change this application to become a multi-instance, load
balanced application, to increase fault tolerance and handle higher load.
