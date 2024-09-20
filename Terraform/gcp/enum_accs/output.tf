output "apis_modified"{
  value = local.apis_modified
  description = "all apis turned on for this terraform desployment"
}

output "main_project_utilized"{
  value = var.gcp_main_project
  description = "main project utilized by onboarding"
}

output "son_projects"{
  value = local.short_project_list
  description = "rest of the projects onboarded"
}

output "d9keyused"{
  value = google_service_account_key.d9key.private_key
  sensitive = true
}
