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

resource "google_compute_firewall" "allow-ingress-ssh" {
  name    = "allow-ingress-ssh"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22", "443"]
  }

  allow {
    protocol = "udp"
    ports    = ["51820"]
  }

  // ingress is the default direction

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ingress-ssh"]
}

resource "google_compute_firewall" "allow-ingress-ssh-and-socks" {
  name    = "allow-ingress-ssh-and-socks"
  network = google_compute_network.net-a.name

  allow {
    protocol = "tcp"
    ports    = ["22", "1080"]
  }

  allow {
    protocol = "udp"
    ports    = ["51820"]
  }

  // ingress is the default direction

  source_ranges = ["192.168.0.0/24"]
  target_tags   = ["ingress-ssh-and-socks"]
}

resource "google_compute_global_address" "private-ssh-address" {
  name          = "private-ssh-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 8
  network       = google_compute_network.net-a.id
}

resource "google_compute_address" "relay-i0001" {
  name       = "relay-i0001-public-address"
  depends_on = [google_compute_firewall.allow-ingress-ssh]
}

resource "google_compute_address" "socks-i0001" {
  name       = "socks-i0001-public-address"
  depends_on = [google_compute_firewall.allow-ingress-ssh-and-socks]
}

resource "google_compute_instance" "virtual-relay-i0001" {
  name         = "virtual-relay-i0001"
  machine_type = "e2-micro"
  depends_on   = [google_compute_firewall.allow-ingress-ssh]
  tags         = ["ingress-ssh"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-minimal-2204-jammy-v20221018"
      size  = 12
    }
  }

  network_interface {
    network = "default"

    access_config {
      nat_ip = google_compute_address.relay-i0001.address
    }
  }

  metadata = {
    ssh-keys = "ubuntu:${file("../common/i0001_ssh_key.pub")}"
  }

  metadata_startup_script = file("../common/ubuntu-jammy-bootstrap-ssh.sh")
}

resource "google_compute_instance" "virtual-socks-i0001" {
  name         = "virtual-socks-i0001"
  machine_type = "e2-micro"
  depends_on   = [google_compute_firewall.allow-ingress-ssh-and-socks]
  tags         = ["ingress-ssh-and-socks"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-minimal-2204-jammy-v20221018"
      size  = 12
    }
  }

  network_interface {
    network = "default"

    access_config {
      nat_ip = google_compute_address.socks-i0001.address
    }
  }

  metadata = {
    ssh-keys = "ubuntu:${file("../common/i0001_ssh_key.pub")}"
  }

  metadata_startup_script = file("../common/ubuntu-jammy-bootstrap-ssh-and-socks.sh")
}

output "relay-public-ip" {
  value = google_compute_instance.virtual-relay-i0001.network_interface.0.access_config.0.nat_ip
}

output "socks-private-ip" {
  value = google_compute_instance.virtual-socks-i0001.network_interface.0.network_ip
}
