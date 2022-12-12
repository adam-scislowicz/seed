provider "google" {
  project = "extropicnet"
  region  = "us-west2"
  zone    = "us-west2-a"
}

resource "google_compute_network" "net-a" {
  auto_create_subnetworks = false
  name                    = "net-a"
  routing_mode            = "REGIONAL"
}

resource "google_compute_subnetwork" "subnet-a" {
  name          = "subnet-a"
  ip_cidr_range = "192.168.0.0/24"
  network       = google_compute_network.net-a.id
}

resource "google_compute_firewall" "allow-ingress-web" {
  name    = "allow-ingress-web"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  // ingress is the default direction

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ingress-web"]
}

resource "google_compute_address" "web-i0001" {
  name       = "web-i0001-public-address"
  depends_on = [google_compute_firewall.allow-ingress-web]
}

data "google_dns_managed_zone" "extropic-net" {
  name = "extropic-net"
}

resource "google_dns_record_set" "a" {
  name         = "www.extropic.net."
  managed_zone = data.google_dns_managed_zone.extropic-net.name
  type         = "A"
  ttl          = 300

  rrdatas = [google_compute_instance.virtual-web-i0001.network_interface.0.access_config.0.nat_ip]
}

resource "google_compute_instance" "virtual-web-i0001" {
  name         = "virtual-web-i0001"
  machine_type = "e2-micro"
  depends_on   = [google_compute_firewall.allow-ingress-web]
  tags         = ["ingress-web"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-minimal-2204-jammy-v20221018"
      size  = 12
    }
  }

  network_interface {
    network = "default"

    access_config {
      nat_ip = google_compute_address.web-i0001.address
    }
  }


  metadata = {
    ssh-keys = "ubuntu:${file("../common/i0001_ssh_key.pub")}"
  }

  metadata_startup_script = file("../common/ubuntu-jammy-bootstrap-web.sh")
}

output "web-public-ip" {
  value = google_compute_instance.virtual-web-i0001.network_interface.0.access_config.0.nat_ip
}
