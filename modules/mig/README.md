# Managed Instance Group (MIG) - Zonal


This module allows creating a zonal managed instance group supporting one or more application versions via instance templates.a health check and an autoscaler can be created, and the managed instance group.





[Cloud Factory Engine Modules Repo](https://https://github.com/GBG-COE/Cloud_Factory_Engine_Modules/tree/main)



## Example usage
use case is shown in the examples below.
```

module "mig" {
  source = "./modules/mig"
  project_id = 
  region = 
  zone = 
  mig_name = "coe-mig-001" 

  network = 
  subnetwork = "projects/${var.project_id}/regions/${var.region}/subnetworks/<<SUBNET NAME>>"
  
  startup_sript= 

  scope = ["https://www.googleapis.com/auth/cloud-platform"]
  
  service_account = 

  min_replicas = 1
  max_replicas = 2

  named_ports = [ {
      name = "http"
      port = "80"
  } ]

}

```




## Variables

| name || type | required | 
|---|---|:---:|:---:|
| project_id | | <code>string</code> | ✓ |  |
| startup_sript | | <code>sh</code> | ✓ |  |
| zone | | <code>string</code> | ✓ |  |
| service_account | | <code>string</code> | ✓ |  |
| scope | | <code>string</code> | ✓ |  |
| region | | <code>string</code> | ✓ |  |
| machine_type | | <code>string</code> | 
| instance_labels  | | <code>string</code> | 
| network   | | <code>string</code> |  ✓ |  |
| subnetwork  | | <code>string</code> |  ✓ |  |
| disk_auto_deletes  | | <code>string</code> | 
| disk_type   | | <code>string</code> |
| min_replicas |
|  max_replicas |
|  named_ports | | <code>list(object)</code> |  ✓ |  |

### Note :  Some variables given default values in `varaibles.tf` refer that and change values as per requirements   

## Outputs

| name | description | sensitive |
|---|---|:---:|
| instance_group | Instance group resource. |  |


<!-- END TFDOC -->