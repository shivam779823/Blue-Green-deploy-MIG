
variable "backends" {
  description = "Map backend indices to list of backend maps."
  type = map(object({
    port                    = optional(number)
    protocol                = optional(string)
    port_name               = optional(string)
    description             = optional(string)
    enable_cdn              = optional(bool)
    compression_mode        = optional(string)
    security_policy         = optional(string, null)
    edge_security_policy    = optional(string, null)
    custom_request_headers  = optional(list(string))
    custom_response_headers = optional(list(string))

    timeout_sec                     = optional(number)
    connection_draining_timeout_sec = optional(number)
    session_affinity                = optional(string)
    affinity_cookie_ttl_sec         = optional(number)

    # health_check = object({
    #   check_interval_sec  = optional(number)
    #   timeout_sec         = optional(number)
    #   healthy_threshold   = optional(number)
    #   unhealthy_threshold = optional(number)
    #   request_path        = optional(string)
    #   port                = optional(number)
    #   host                = optional(string)
    #   logging             = optional(bool)
    # })

    # log_config = object({
    #   enable      = optional(bool)
    #   sample_rate = optional(number)
    # })

    groups = list(object({
      group = string

      balancing_mode               = optional(string)
      capacity_scaler              = optional(number)
      description                  = optional(string)
      max_connections              = optional(number)
      max_connections_per_instance = optional(number)
      max_connections_per_endpoint = optional(number)
      max_rate                     = optional(number)
      max_rate_per_instance        = optional(number)
      max_rate_per_endpoint        = optional(number)
      max_utilization              = optional(number)
    }))
    # iap_config = object({
    #   enable               = bool
    #   oauth2_client_id     = optional(string)
    #   oauth2_client_secret = optional(string)
    # })
    cdn_policy = optional(object({
      cache_mode                   = optional(string)
      signed_url_cache_max_age_sec = optional(string)
      default_ttl                  = optional(number)
      max_ttl                      = optional(number)
      client_ttl                   = optional(number)
      negative_caching             = optional(bool)
      negative_caching_policy = optional(object({
        code = optional(number)
        ttl  = optional(number)
      }))
      serve_while_stale = optional(number)
      cache_key_policy = optional(object({
        include_host           = optional(bool)
        include_protocol       = optional(bool)
        include_query_string   = optional(bool)
        query_string_blacklist = optional(list(string))
        query_string_whitelist = optional(list(string))
        include_http_headers   = optional(list(string))
        include_named_cookies  = optional(list(string))
      }))
    }))
  }))
}

variable "lb_name" {
    default = "test-lb-001"
}

variable "https_required" {
  type = bool
  default = false

}



variable "health_check_port" {
  default =  "80" 
}

variable "load_balancing_scheme" {
  default = "EXTERNAL_MANAGED"
}




variable "region" {
  
}

variable "project_id" {
  
}

