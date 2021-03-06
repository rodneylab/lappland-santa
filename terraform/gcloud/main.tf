variable "bucket" {}
variable "image" {}
variable "image_file" {}
variable "image_name" {}
variable "image_family" { default = "openbsd-amd64-68" }
variable "lappland_id" { default = "lappland" }
variable "mail_server" {}
variable "project_id" {}
variable "region" {}
variable "server_name" {}
variable "ssh_key" {}
variable "ssh_port" {}
variable "wg_port" {}
variable "firewall_select_source" {}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.58.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_compute_image" "lappland_santa_image" {
  name = var.image_name
  raw_disk {
    source = "https://storage.googleapis.com/${var.bucket}/${var.image_file}"
    # sha1 = "003b5dca54c0931480a5e055659140b94cf87d76" hash bedfore extracting
  }
  family  = var.image_family
  project = var.project_id
}

resource "google_compute_network" "vpc_network" {
  name         = "lappland"
  routing_mode = "REGIONAL"
}

resource "google_compute_firewall" "lapplandsanta" {
  name          = "lapplandsanta"
  network       = google_compute_network.vpc_network.name
  direction     = "INGRESS"
  source_ranges = split(",", var.firewall_select_source)
  allow {
    protocol = "tcp"
    ports    = [var.ssh_port, "993"]
  }
  allow {
    protocol = "udp"
    ports    = [var.wg_port]
  }
  target_tags = ["lappland-santa"]
}

resource "google_compute_firewall" "lapplandsantaweb" {
  name      = "lapplandsantaweb"
  network   = google_compute_network.vpc_network.name
  direction = "INGRESS"
  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
  target_tags = ["lappland-santa"]
}

resource "google_compute_firewall" "lapplandsantamta" {
  name      = "lapplandsantamta"
  network   = google_compute_network.vpc_network.name
  direction = "INGRESS"
  allow {
    protocol = "tcp"
    ports    = ["25", "465", "587"]
  }
  target_tags = ["lappland-santa"]
}

resource "google_compute_address" "static" {
  name = var.server_name
}

resource "google_project_service" "service" {
  for_each = toset([
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com"
  ])

  service = each.key

  project            = var.project_id
  disable_on_destroy = false
}

data "google_compute_zones" "available" {
  project = var.project_id
}

resource "random_shuffle" "zones" {
  input        = data.google_compute_zones.available.names
  result_count = 1
}

resource "google_compute_instance" "lappland_santa" {
  name         = var.server_name
  zone         = random_shuffle.zones.result[0]
  machine_type = "f1-micro"
  tags         = ["lappland-santa"]

  boot_disk {
    initialize_params {
      image = google_compute_image.lappland_santa_image.self_link
    }
  }

  metadata = {
    instance-type = "lappland-santa"
    lappland-id   = var.lappland_id
    ssh-keys      = var.ssh_key
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
      nat_ip                 = google_compute_address.static.address
      network_tier           = "PREMIUM"
      public_ptr_domain_name = var.mail_server
    }
  }
}

output "external_ip" {
  value = google_compute_instance.lappland_santa.network_interface.0.access_config.0.nat_ip
}
