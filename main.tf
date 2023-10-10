

/******************************************
	VPC 
 *****************************************/

module "usc1-trust-vpc-001" {
 source = "./modules/vpc"
  project_id              = var.project_id
  network_name            = "trust-vpc-001"
  auto_create_subnetworks = false
}

/******************************************
	subnet
 *****************************************/

module "usc1-trustsubnet-001" {
  source = "./modules/subnet"
  project_id   = var.project_id
  network_name = module.usc1-trust-vpc-001.vpc.self_link

    subnets = [{
    subnet_name           = "trustsubnet-001"
    subnet_region         = "us-central1"
    subnet_ip             = "10.10.0.0/24"
    subnet_flow_logs      = "false"
    subnet_private_access = "true"
    }
  ]
  depends_on = [
    module.usc1-trust-vpc-001
  ]
}

/******************************************
	Firewall
 *****************************************/

module "app-fw-001" {
  source = "./modules/firewall"
  firewall_description = "Creates firewall rule targeting tagged instances"
  firewall_name        = "app-fw"
  network              = module.usc1-trust-vpc-001.vpc.self_link
  project_id           = var.project_id
  target_tags          = []
  rules_allow 	       = [
    	{
      			protocol = "TCP"
      			ports    = ["80", "8080"]
    	}
  ]
  source_ranges = ["0.0.0.0/0"]
  depends_on = [
    module.usc1-trust-vpc-001
  ]
}


/******************************************
	Router-NAT
 *****************************************/
module "router-nat" {
  source = "./modules/router-nat"
  name     = "bg-router"
  region   = var.region
  network  = module.usc1-trust-vpc-001.vpc.self_link
  nat_name = "bg-nat"

}

/******************************************
	LB
 *****************************************/

module "lb" {
  source = "./modules/https-lb"
   lb_name             = "http-lb-001"
   project_id         = var.project_id
   region = var.region
  backends = {
    default = {
      protocol    = "HTTP"
      port        = 8080
      port_name   = "http"
      timeout_sec = 10
      enable_cdn  = false

      groups = [
        {
          group = module.green-mig.instance_group
          capacity_scaler = "${var.active_color == "green" ? 1 : 0}"

           
        },
         {
          group = module.blue-mig.instance_group
          capacity_scaler = "${var.active_color == "blue" ? 1 : 0}"
           
        },
      ]
    }
  }

  depends_on = [ module.green-mig , module.blue-mig ]
}


/******************************************
	MIGs
 *****************************************/

module "green-mig" {
    source = "./modules/mig"
    project_id    = var.project_id
    region        = var.region
    network       = module.usc1-trust-vpc-001.vpc.name
    subnetwork    = "projects/${var.project_id}/regions/${var.region}/subnetworks/trustsubnet-001"
    scope         = ["https://www.googleapis.com/auth/cloud-platform"]
    service_account = var.service_account
    startup_sript = templatefile("./script.sh", { color = "Green"  ,  version = "v1", ns = "Dev"})
    mig_name        = "green"
    min_replicas    = 1
    max_replicas    = 2
    color = "green"
    app_version = "v1"
    namespace = "dev"
    named_ports = [{
    name = "http"
    port = "80"
  }]
  depends_on = [
    module.usc1-trustsubnet-001,
    module.usc1-trust-vpc-001,
  ]
}



module "blue-mig" {
    source = "./modules/mig"
    project_id    = var.project_id
    region        = var.region
    network       = module.usc1-trust-vpc-001.vpc.name
    subnetwork    = "projects/${var.project_id}/regions/${var.region}/subnetworks/trustsubnet-001"
    scope         = ["https://www.googleapis.com/auth/cloud-platform"]
    service_account = var.service_account
    startup_sript = templatefile("./script.sh", { color = "Blue"  ,  version = "v1", ns = "Dev"})

    mig_name        = "blue"
    min_replicas    = 1
    max_replicas    = 2
    color = "blue"
    app_version = "v1"
    namespace = "dev"
    named_ports = [{
    name = "http"
    port = "80"
  }]
  depends_on = [
    module.usc1-trustsubnet-001,
    module.usc1-trust-vpc-001,
  ]
}
