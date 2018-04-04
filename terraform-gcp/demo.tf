provider "google" {
  project     = "USERNAME-1837637" // Your project ID here.
  region      = "us-central1"
}

resource "google_compute_instance" "default" {
  name         = "test"
  machine_type = "n1-standard-1"
  zone         = "us-central1-b"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-8"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }

  //metadata_startup_script = "echo hi > /test.txt"

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }

  metadata {
    ssh-keys = "USERNAME:${file("~/.ssh/id_rsa.pub")}"
  }

}
