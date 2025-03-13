variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "us-central1"
}

variable "instance_count" {
  description = "Number of instances in the managed instance group"
  type        = number
  default     = 2
}

variable "google_credentials_file" {
  description = "Path to the Google Cloud service account key file"
  type        = string
}
