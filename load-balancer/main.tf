resource "google_compute_global_address" "default" {
  name = "lb-static-ip"
}

resource "google_compute_backend_service" "default" {
  name                  = "backend-service"
  load_balancing_scheme = "EXTERNAL"
  health_checks         = [google_compute_health_check.default.id]
  backend {
    group = var.instance_group
  }
}

resource "google_compute_health_check" "default" {
  name = "health-check"
  http_health_check {
    request_path = "/"
  }
}

resource "google_compute_url_map" "default" {
  name        = "url-map"
  default_service = google_compute_backend_service.default.id
}

resource "google_compute_target_http_proxy" "default" {
  name    = "http-proxy"
  url_map = google_compute_url_map.default.id
}

resource "google_compute_global_forwarding_rule" "default" {
  name       = "global-forwarding-rule"
  target     = google_compute_target_http_proxy.default.id
  port_range = "80"
  ip_address = google_compute_global_address.default.address
}
