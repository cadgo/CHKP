provider "google" {
  credentials = file("./key.json")
}

data "google_projects" "all_projects" {
  filter="lifecycleState:ACTIVE"
}

resource "null_resource" "projects"{
  for_each = toset(data.google_projects.all_projects.projects[*].project_id)

  triggers={
    name=each.value
  }
}

output "objects" {
  value = [for users in null_resource.projects : users.triggers.name] 
}

#output "projects_id" {
#  value = data.google_projects.all_projects.projects[*].project_id
#}
