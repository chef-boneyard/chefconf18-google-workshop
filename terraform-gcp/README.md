# terraform-gcp

You're probably wondering why we are demoing [terraform](https://www.terraform.io/)
and GCP. Well, there is a [chef-provisioner](https://www.terraform.io/docs/provisioners/chef.html)
that allows you to do your Day 0, with GCP, and have Chef take care of your
Day 1 and Day 2!

Lets get you set up.

## Setup

1. Go to <https://www.terraform.io/downloads.html> and download the correct version for your operating system.
1. run `terraform` on the command line to see if you have it correctly installed. <https://www.terraform.io/intro/getting-started/install.html>

## Commands

1. Pull down the file [demo.tf](./demo.tf) and run `terraform init` in that directory.
1. Open the file change the `PROJECT-ID` to yours, and run `terraform apply`.
1. You should see the instance spun up in only a few seconds, then run `gcloud compute ssh test` and you should be right into the machine!
1. Run `terraform destroy` and type `yes` as the value and you'll clean it up.
1. Now, lets move onto getting Chef involved.
1. Pull down the file [chef_demo.tf](./chef_demo.tf) and run `terraform init` in that directory.
1. Open the file to change the options around, and put your hosted Chef server account in if you have one.
1. Now run `terraform apply` and you'll bootstrap a machine in GCP and connect it to the Chef server!
