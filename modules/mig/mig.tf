###########################################################
## VM Template
############################################################

resource "google_compute_instance_template" "compute_template" {
  project     = var.project_id
  name        = "${var.mig_name}-instance-template"
  region      = var.region 
  machine_type = var.machine_type
  tags         = var.instance_tags  
  labels = var.instance_labels

  network_interface {
    network            = var.network 
    subnetwork         = var.subnetwork
  }

  disk {
    auto_delete  = var.disk_auto_delete 
    boot         = true
    source_image = "ubuntu-os-cloud/ubuntu-2004-lts"  
    disk_type    = var.disk_type    
    disk_size_gb = var.disk_size_gb 
    mode         = var.mode         
  }

  service_account {
    email  = var.service_account
    scopes = var.scope
  }

  metadata_startup_script=var.startup_sript
 
  scheduling {    
    preemptible       = var.preemptible        
    automatic_restart = var.automatic_restart  
  }

  lifecycle {
    create_before_destroy = true
  }
}


######################################################
## MIG 
######################################################

resource "google_compute_instance_group_manager" "mig" {
  base_instance_name = var.hostname
  project            = var.project_id
  name               = var.mig_name
  zone               = var.zone
  
  version {
    name              = "${var.hostname}-mig-version-0"
    instance_template = google_compute_instance_template.compute_template.self_link
  }

  dynamic "named_port" {
    for_each = var.named_ports
    content {
      name = lookup(named_port.value, "name", null)
      port = lookup(named_port.value, "port", null) 
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.tcp.self_link
    initial_delay_sec = 300
  }
}


#####################################################
## Auto-Scaler
#####################################################

resource "google_compute_autoscaler" "autoscaler" {
  project  = var.project_id
  name     = "${var.mig_name}-autoscaler"
  zone     = var.zone

  target = google_compute_instance_group_manager.mig.self_link

  autoscaling_policy {
    max_replicas    = var.max_replicas
    min_replicas    = var.min_replicas
    cooldown_period = var.cooldown_period
    mode            = var.autoscaling_mode
  }
}


###########################################################
## Health-Check 
############################################################

resource "google_compute_health_check" "http" {
  count = var.http_health_check ? 1 : 0
  project = var.project_id
  name    = "${var.mig_name}-https-healthcheck"

  check_interval_sec  = var.health_check["check_interval_sec"]
  healthy_threshold   = var.health_check["healthy_threshold"]
  timeout_sec         = var.health_check["timeout_sec"]
  unhealthy_threshold = var.health_check["unhealthy_threshold"]

  http_health_check {
    port         = var.health_check["port"]
    request_path = var.health_check["request_path"]
    host         = var.health_check["host"]
    response     = var.health_check["response"]
    proxy_header = var.health_check["proxy_header"]
  }

}

resource "google_compute_health_check" "tcp" {
  project = var.project_id
  name    = "${var.mig_name}-tcp-healthcheck"

  check_interval_sec  = var.health_check["check_interval_sec"]
  healthy_threshold   = var.health_check["healthy_threshold"]
  timeout_sec         = var.health_check["timeout_sec"]
  unhealthy_threshold = var.health_check["unhealthy_threshold"]

  tcp_health_check {
    port         = var.health_check["port"]
  }

}