terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = ">= 5.0"
    }
  }

  # Use a remote backend to store the Terraform state in GCS
  backend "gcs" {
    bucket = "[YOUR_GCP_PROJECT_ID]-tfstate"
    prefix = "terraform/state"
  }
}

provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}

# Create a GCS bucket for Terraform state
resource "google_storage_bucket" "tf_state_bucket" {
  name     = "[YOUR_GCP_PROJECT_ID]-tfstate"
  location = "US"
  uniform_bucket_level_access = true
}

resource "google_compute_instance" "microservice_vm" {
  name         = "ipl-microservice-vm"
  machine_type = "e2-micro"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network = "default"
    access_config {
      # External IP address for public access
    }
  }

  # Configure and run the microservices using a startup script
  metadata_startup_script = <<-EOT
    #!/bin/bash
    sudo apt-get update
    sudo apt-get install -y docker.io
    sudo usermod -aG docker $(whoami)

    # Pull images from Artifact Registry
    docker run -d --name team-service -p 5000:5000 us-central1-docker.pkg.dev/${var.gcp_project_id}/ipl-repo/team-service:latest
    docker run -d --name match-service -p 5001:5001 us-central1-docker.pkg.dev/${var.gcp_project_id}/ipl-repo/match-service:latest
  EOT
}

resource "google_compute_firewall" "allow_microservices" {
  name    = "allow-microservices"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["5000", "5001"]
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_artifact_registry_repository" "ipl_repo" {
  location      = "us-central1"
  repository_id = "ipl-repo"
  format        = "DOCKER"
}
