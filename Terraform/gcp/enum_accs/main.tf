provider "google" {
  credentials = file("./key.json")
}

data "google_projects" "all_projects" {
  filter="lifecycleState:ACTIVE"
}

#resource "google_project_service" "k8s_api" {
#  for_each = toset(data.google_projects.all_projects.projects[*].project_id)
#  project = each.value
#  service = "container.googleapis.com"
#
#  disable_on_destroy = true
#}

resource "google_project_service" "k8s_api" {
  count = var.kubernetes_enabler.k8s ? length(data.google_projects.all_projects.projects[*].project_id) : 0
  project = element(data.google_projects.all_projects.projects,count.index).project_id
  service = "container.googleapis.com"

  disable_on_destroy = true
}


output "projects_id" {
  value = data.google_projects.all_projects.projects[*].project_id
}
