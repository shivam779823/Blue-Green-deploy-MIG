
/******************************************
	forwading rule http/https
 *****************************************/

resource "google_compute_global_forwarding_rule" "http-fw-rule" {
  name                  = "${var.lb_name}-fw-rule"
  port_range            = "80"
  target                = google_compute_target_http_proxy.http-proxy.self_link
  load_balancing_scheme = "EXTERNAL_MANAGED"
}


resource "google_compute_global_forwarding_rule" "https-fw-rule" { 
  count                 = var.https_required ? 1 : 0  
  name                  = "${var.lb_name}-fw-rule"
  port_range            = "443"
  target                = google_compute_target_https_proxy.https-proxy.*.self_link
  load_balancing_scheme = var.load_balancing_scheme
}


# /******************************************
#   Http/s proxy
#  *****************************************/

resource "google_compute_target_http_proxy" "http-proxy" {
  name = "${var.lb_name}-http-proxy"
  url_map = google_compute_url_map.url_map.self_link
}

#HTTPS proxy when its true
resource "google_compute_target_https_proxy" "https-proxy" {
  count             = var.https_required ? 1 : 0   
  name             =  "${var.lb_name}-http-proxy"
  ssl_certificates = [google_compute_ssl_certificate.ssl_certificates.*.self_link]
  url_map          = google_compute_url_map.url_map.self_link
}


resource "google_compute_ssl_certificate" "ssl_certificates" {
  count                 = var.https_required ? 1 : 0   
  name_prefix =  "${var.lb_name}-"
  private_key = var.https_required ? file("example.key") : null
  certificate = var.https_required ? file("example.crt") : null
}


/******************************************
  URL MAP
 *****************************************/

resource "google_compute_url_map" "url_map" {
  name            = var.lb_name
  default_service = google_compute_backend_service.backend_service[keys(var.backends)[0]].self_link

}

/******************************************
  Backend
 *****************************************/

resource "google_compute_backend_service" "backend_service" {
  for_each = var.backends
  
  name                  = "test-bc-svc"
  health_checks         = [google_compute_health_check.health_checks.self_link]
  
  load_balancing_scheme = var.load_balancing_scheme
  port_name = lookup(each.value, "port_name", "http")
  protocol  = lookup(each.value, "protocol", "HTTP")

 dynamic "backend" {
    for_each = toset(each.value["groups"])
    content {
      description = lookup(backend.value, "description", null)
      group       = lookup(backend.value, "group")

      balancing_mode               = lookup(backend.value, "balancing_mode")
      capacity_scaler              = lookup(backend.value, "capacity_scaler")
      max_connections              = lookup(backend.value, "max_connections")
      max_connections_per_instance = lookup(backend.value, "max_connections_per_instance")
      max_connections_per_endpoint = lookup(backend.value, "max_connections_per_endpoint")
      max_rate                     = lookup(backend.value, "max_rate")
      max_rate_per_instance        = lookup(backend.value, "max_rate_per_instance")
      max_rate_per_endpoint        = lookup(backend.value, "max_rate_per_endpoint")
      max_utilization              = lookup(backend.value, "max_utilization")
    }
  }
}
/******************************************
  Health Check
 *****************************************/

resource "google_compute_health_check" "health_checks" {
  name                = "${var.lb_name}-hc"
  healthy_threshold   = 2
  check_interval_sec  = 5
  unhealthy_threshold = 2
  timeout_sec         = 5

  tcp_health_check {
    port_specification = "USE_SERVING_PORT"    
  }
}
