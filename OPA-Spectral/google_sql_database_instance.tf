#google_sql_database_instance should not have settings.ip_configuration.require_ssl=false

resource "google_sql_database_instance" "postgres" {
  name             = "postgres-instance-${random_id.db_name_suffix.hex}"
  database_version = "POSTGRES_15"

  settings {
    tier = "db-f1-micro"
#
    ip_configuration {
      require_ssl = false
      dynamic "authorized_networks" {
        for_each = google_compute_instance.apps
        iterator = apps

        content {
          name  = apps.value.name
          value = apps.value.network_interface.0.access_config.0.nat_ip
        }
     }

     dynamic "authorized_networks" {
       for_each = local.onprem
       iterator = onprem

       content {
         name  = "onprem-${onprem.key}"
         value = onprem.value
       }
     }
    }
   }
}  
