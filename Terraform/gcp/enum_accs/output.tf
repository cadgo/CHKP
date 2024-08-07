output "projects_id"{
  value = data.google_projects.all_projects.projects[*].project_id
  description = "all projects modified"
}

output "apis_modified"{
  value = local.apis_modified
  description = "all apis turned on for this terraform desployment"
}
