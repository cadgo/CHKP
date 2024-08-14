locals {
  apis_modified = {for api,status in var.d9_gcp_api_enabler : api => status if status==true}
  short_project_list = [for x in data.google_projects.all_projects.projects[*].project_id: x if x!="${var.gcp_main_project}"] 
  projects_and_permissions = {for key, val in data.google_projects.all_projects.projects[*].project_id: val=>[for x in toset(var.gcp_permissions): x]}
}
