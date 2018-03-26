# gcloud

Awesome! `gcloud` is a great tool you should get used to working with. Here are
some helpful links and commands to get you started for the compute side. You can
do so much more, learn investigate....hell you can even set up a k8s instance in
one command!

(If you do learn something cool, put in a PR against this so we can all share this
cheat sheet.)

## Links

- <https://cloud.google.com/sdk/gcloud/> - Main gcloud documentation site.

## Compute Examples

#### How to list public images

```bash
gcloud compute images list
```

##### How to spin up a generic instance

```bash
gcloud compute instances create instance1 --image-project=ubuntu-1604-lts --machine-type g1-small
gcloud compute instances create instance1 --image-project=centos-cloud --machine-type g1-small
```

Note: this is good to have as an alias or something, a good way to have a throw-a-away machine.

```bash
alias gcp_create="gcloud compute instances create temp-`date +%F` --image-project=ubuntu-1604-lts --machine-type g1-small && gcloud compute ssh temp-`date +%F`"
alias gcp_delete="gcloud compute instances delete temp-`date +%F`"
```

##### How to spin up an 8 gig machine

```
gcloud compute instances create instance1 --machine-type n1-standard-2
```

##### How to spin up an 16 gig machine

```
gcloud compute instances create instance1 --machine-type n1-standard-4
```

##### How to ssh into a machine you created

```
gcloud compute ssh instance1
```

##### How to delete the instance

```
gcloud compute instances delete instance1
```
