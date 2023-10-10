##Required

#Instance Template
variable "machine_type" {
  type        = string 
  description = "Machine type for the VMs in the instance group."
  default     = "e2-medium"
}
/*
variable service_account_scopes {
  description = "List of scopes for the instance template service account"
  type        = list(string)

  default = [
    "https://www.googleapis.com/auth/compute",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring.write",
    "https://www.googleapis.com/auth/devstorage.full_control",
  ]
}
*/

#MIG
variable "hostname" {
  description = "Hostname prefix for instances"
  type        = string
  default     = "mig-vm"
}


variable "mig_name" {
  description = "Managed instance group name."
  type        = string
  default     = "mig-1"
}

variable "region" {
  description = "Region for cloud resources."
  default     = "us-central1"
}

variable "zone" {
  description = "The GCP zone where the managed instance group resides."
  type        = string
  default     = "us-central1-a"
}

variable "named_ports" {
  description = "Named name and named port."
  type = list(object({
    name = string
    port = number
  }))
  default = []
}

variable "wait_for_instances" {
  description = "wait for all instances to be created/updated before returning."
  type        = bool
  default     = true
}


variable "service_account" {
  type = string
}

variable "scope" {
  type = set(string)
}

#autoscaler
variable "max_replicas" {
  description = "The maximum number of instances that the autoscaler can scale up to."
  default     = 10
  type        = number
}

variable "min_replicas" {
  description = "The minimum number of replicas that the autoscaler can scale down to."
  default     = 2
  type        = number
}

# Healthcheck
variable "health_check" {
  description = "Health check to determine whether instances are responsive and able to do work"
  type = object({
    type                = string
    check_interval_sec  = number
    healthy_threshold   = number
    timeout_sec         = number
    unhealthy_threshold = number
    response            = string
    proxy_header        = string
    port                = number
    request_path        = string
    host                = string
  })
  default = {
    type                = ""
    check_interval_sec  = 30
    healthy_threshold   = 1
    timeout_sec         = 10
    unhealthy_threshold = 5
    response            = ""
    proxy_header        = "NONE"
    port                = 80
    request_path        = "/"
    host                = ""
  }
}


#optional

#Instance Template
variable "project_id" {
  type        = string
  description = "The GCP project ID"
  default     = null
}

variable "instance_tags" {
  description = "Tags added to instances."
  type        = list(string)
  default     = []
}

variable "instance_labels" {
  description = "Labels added to instances."
  type        = map(string)
  default     = {}
}

variable "network" {
  description = "Name of the network to deploy instances to."
  default     = "default"
}

variable "subnetwork" {
  description = "The subnetwork to deploy to"
  default     = "default"
}

variable "disk_auto_delete" {
  description = "Whether or not the disk should be auto-deleted."
  default     = true
}

variable "compute_image" {
  description = "Image used for compute VMs."
  default     = "projects/debian-cloud/global/images/family/debian-11"
}

variable "disk_type" {
  description = "The GCE disk type. Can be either pd-ssd, local-ssd, or pd-standard."
  default     = "pd-ssd"
}

variable "disk_size_gb" {
  description = "The size of the image in gigabytes. If not specified, it will inherit the size of its base image."
  default     = 0
}

variable "mode" {
  description = "The mode in which to attach this disk, either READ_WRITE or READ_ONLY."
  default     = "READ_WRITE"
}
/*
# variable service_account_email {
#   description = "The email of the service account for the instance template."
#   default     = "default"
# }

variable "ssh_user" {
  description = "the SSH user name."
  default     = " "
}

variable "public_key_path" {
  description = "the path to the public key file."
  default     = " "
}
*/
variable "preemptible" {
  description = "Use preemptible instances - lower price but short-lived instances."
  default     = "false"
}

variable "automatic_restart" {
  description = "Automatically restart the instance if terminated by GCP - Set to false if using preemptible instances"
  default     = "true"
}

variable "target_size" {
  description = "The target number of running instances for this managed instance group."
  type        = number
  default     = 1
}

# Autoscaler
variable "autoscaling_enabled" {
  description = "Creates an autoscaler for the managed instance group"
  default     = "false"
  type        = string
}

variable "cooldown_period" {
  description = "The number of seconds that the autoscaler should wait before it starts collecting information from a new instance."
  default     = 60
  type        = number
}

variable "autoscaling_mode" {
  description = "Operating mode of the autoscaling policy. the default value is ON."
  type        = string
  default     = null
}
variable "name_prefix" {
  type    = string
  default = "Default-1"

}

variable "http_health_check" {
  default = false
}


variable "color" {
  
}
variable "app_version" {
  
}

variable "namespace" {
  
}

variable "startup_sript" {
  
}