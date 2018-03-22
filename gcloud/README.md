# gcloud

Awesome! `gcloud` is a great tool you should get used to working with. Here are
some helpful links and commands to get you started.

## Links

- <https://cloud.google.com/sdk/gcloud/> - Main gcloud documentation site.

## Examples

```
# list images
gcloud compute images list

# how to spin up a generic instance
gcloud compute instances create instance1 --image-family=ubuntu-1604-lts --machine-type g1-small
gcloud compute instances create instance1 --image-family=centos-7 --machine-type g1-small

# how to spin up an 8 gig machine
gcloud compute instances create instance1 --machine-type n1-standard-2
# how to spin up an 16 gig machine
gcloud compute instances create instance1 --machine-type n1-standard-4

# how to ssh into a machine you created
gcloud compute ssh instance1

# how to delete an instance
gcloud compute instances delete instance1
```
