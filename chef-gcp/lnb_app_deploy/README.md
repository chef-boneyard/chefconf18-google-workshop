Placeholder

# Load Balancer Deployment

This deployment is split into 2 "phases", as we will need resources to be
queried during recipe compilation that will be created throughout the recipe
execution (i.e. the static IP address for the balancer).

  * Step 1: We'll create all the resources for our application:
    - Network `gcompute_network`
    - Instance Template `gcompute_instance_template`
    - HTTP Health Check `gcompute_http_health_check`
    - Target Pool `gcompute_target_pool`
    - Managed Instance Group `gcompute_instance_group_manager`
    - Static IP Address `gcompute_address`
    - Balancer Firewall Rule `gcompute_firewall`

```
chef-client -z --runlist 'recipe[chef-gcp-workshop::up_lnb_app]'
```

It will bring everything but the forwarding rule, which is created on step 2
below...

  * Step 2
    - Fetch the static IP from step 1
    - Create Forwarding Rule `gcompute_forwarding_rule` and assign the static IP
      to it

```
chef-client -z --runlist 'recipe[chef-gcp-workshop::up_lnb_app_step_2]'
```

# Verifying load balancer working

In the script below replace `xxx.xxx.xxx.xxx` with the IP address of the
balancer, that you can find the Developer Console or by running `gcloud compute
forwarding-rules list`.

```
export BALANCER_IP_ADDRESS=xxx.xxx.xxx.xxx
for i in $(seq 1 20); do \
  curl http://${BALANCER-IP-ADDRESS}/ 2>/dev/null \
      | grep code | sed -e 's/.*code.\(.*\)..code.*/\1/g';
done | sort | uniq -c
```

The script will make 20 requests to the load balanced application, extract the
machine name (that we put in the page so we can verify it is really hitting
multiple machines), and count them by machine name.

This should output a count of how many requests went to which machine, such as:

```
  8 my-lnb-app-example-7tst
  7 my-lnb-app-example-9f8q
  5 my-lnb-app-example-x6f7
```

# Deleting the deployment

Simply run the `down_lnb_app` recipe:

```
chef-client -z --runlist 'recipe[chef-gcp-workshop::down_lnb_app]'
```

# Security Considerations

To make it easier to test each machine we added the `http-server` network tag.
That allows direct access to the instances, something **you do not want this in
a production environment**. For production environments remove the `http-server`
tag from the Instance Template, so the only network allowed is from Google's
Network Balancers.

You may also **not** want to expose the machine names. This is done just to show
to you the balancing in action.
