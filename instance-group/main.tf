resource "google_compute_instance_template" "default" {
  name_prefix  = "instance-template"
  machine_type = "e2-medium"
  region       = var.region

  disk {
    source_image = "debian-cloud/debian-11"
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network = "default"
  }

  metadata_startup_script = <<EOT
    #!/bin/bash
    sudo apt update
    sudo apt install -y apache2
    echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html
    sudo systemctl restart apache2
  EOT
}

resource "google_compute_region_instance_group_manager" "mig" {
  name               = "my-mig"
  region             = var.region
  base_instance_name = "web-instance"
  version {
    instance_template = google_compute_instance_template.default.id
  }
  target_size = var.instance_count
}

resource "google_compute_region_autoscaler" "autoscaler" {
  name   = "my-autoscaler"
  region = var.region  # Use region instead of zone
  target = google_compute_region_instance_group_manager.mig.id

  autoscaling_policy {
    max_replicas    = 5
    min_replicas    = 1
    cooldown_period = 60

    cpu_utilization {
      target = 0.6
    }
  }
}
