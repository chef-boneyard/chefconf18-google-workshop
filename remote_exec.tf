/*
This is a test server definition for GCE+Terraform for GH-9564
*/

provider "google" {
  project = "${var.project_id}" // Your project ID here.
  region  = "${var.region}"
}

resource "google_compute_firewall" "gh-9564-firewall-externalssh" {
  name    = "gh-9564-firewall-externalssh"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["externalssh"]
}

resource "google_compute_instance" "mynode1" {
  name         = "mynode1"
  machine_type = "f1-micro"
  zone         = "${var.zone}"
  tags         = ["externalssh"]

  boot_disk {
    initialize_params {
      image = "${var.image}" # i.e. centos-cloud/centos-7
    }
  }

  network_interface {
    network = "default"

    access_config {
      # Ephemeral
    }
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "${var.user}"
      timeout     = "500s"
      private_key = "${file("~/.ssh/google_compute_engine")}"
    }

    inline = [
      "touch /tmp/temp.txt",
    ]
  }

  # Ensure firewall rule is provisioned before server, so that SSH doesn't fail.
  depends_on = ["google_compute_firewall.gh-9564-firewall-externalssh"]

  service_account {
    scopes = ["compute-ro"]
  }

  metadata {
    ssh-keys = "USERNAME:${file("~/.ssh/google_compute_engine.pub")}"
  }
}
