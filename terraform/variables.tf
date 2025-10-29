variable "gcp_project_id" {
  description = "The ID of the GCP project"
  type        = string
}

variable "gcp_region" {
  description = "The GCP region to deploy resources to"
  type        = string
  default     = "us-central1"
}
