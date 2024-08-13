provider "google" {
  credentials = file("~/.secrets_cdz/key.json")
}

data "google_projects" "all_projects" {
  filter="lifecycleState:ACTIVE"
}


resource "google_project_service" "k8s_api" {
  count = var.d9_gcp_api_enabler.k8s_api ? length(data.google_projects.all_projects.projects[*].project_id) : 0
  project = element(data.google_projects.all_projects.projects,count.index).project_id
  service = "container.googleapis.com"

  disable_on_destroy = true
}

resource "google_project_service" "kms_api" {
  count = var.d9_gcp_api_enabler.kms_api ? length(data.google_projects.all_projects.projects[*].project_id) : 0
  project = element(data.google_projects.all_projects.projects,count.index).project_id
  service = "cloudkms.googleapis.com"

  disable_on_destroy = true
}

resource "google_project_service" "iam_api" {
  count = var.d9_gcp_api_enabler.iam_api ? length(data.google_projects.all_projects.projects[*].project_id) : 0
  project = element(data.google_projects.all_projects.projects,count.index).project_id
  service = "iam.googleapis.com"

  disable_on_destroy = true
}

resource "google_project_service" "appeng_api" {
  count = var.d9_gcp_api_enabler.appeng_api ? length(data.google_projects.all_projects.projects[*].project_id) : 0
  project = element(data.google_projects.all_projects.projects,count.index).project_id
  service = "appengine.googleapis.com"

  disable_on_destroy = true
}

resource "google_project_service" "bigquery_api" {
  count = var.d9_gcp_api_enabler.bigquery_api ? length(data.google_projects.all_projects.projects[*].project_id) : 0
  project = element(data.google_projects.all_projects.projects,count.index).project_id
  service = "bigquery.googleapis.com"

  disable_on_destroy = true
}

resource "google_project_service" "admskd_api" {
  count = var.d9_gcp_api_enabler.admsdk_api ? length(data.google_projects.all_projects.projects[*].project_id) : 0
  project = element(data.google_projects.all_projects.projects,count.index).project_id
  service = "admin.googleapis.com"

  disable_on_destroy = true
}

resource "google_project_service" "cloudfunc_api" {
  count = var.d9_gcp_api_enabler.cloudfunc_api ? length(data.google_projects.all_projects.projects[*].project_id) : 0
  project = element(data.google_projects.all_projects.projects,count.index).project_id
  service = "cloudfunctions.googleapis.com"

  disable_on_destroy = true
}

resource "google_project_service" "cloudsql_api" {
  count = var.d9_gcp_api_enabler.cloudsql_api ? length(data.google_projects.all_projects.projects[*].project_id) : 0
  project = element(data.google_projects.all_projects.projects,count.index).project_id
  service = "sqladmin.googleapis.com"

  disable_on_destroy = true
}

resource "google_project_service" "cloudbigtable_api" {
  count = var.d9_gcp_api_enabler.cloudbigtable_api ? length(data.google_projects.all_projects.projects[*].project_id) : 0
  project = element(data.google_projects.all_projects.projects,count.index).project_id
  service = "bigtableadmin.googleapis.com"

  disable_on_destroy = true
}

resource "google_project_service" "pubsub_api" {
  count = var.d9_gcp_api_enabler.pubsub_api ? length(data.google_projects.all_projects.projects[*].project_id) : 0
  project = element(data.google_projects.all_projects.projects,count.index).project_id
  service = "pubsub.googleapis.com"

  disable_on_destroy = true
}

resource "google_project_service" "cloudmemredis_api" {
  count = var.d9_gcp_api_enabler.cloudmem_api ? length(data.google_projects.all_projects.projects[*].project_id) : 0
  project = element(data.google_projects.all_projects.projects,count.index).project_id
  service = "redis.googleapis.com"

  disable_on_destroy = true
}

resource "google_project_service" "servusage_api" {
  count = var.d9_gcp_api_enabler.servusage_api ? length(data.google_projects.all_projects.projects[*].project_id) : 0
  project = element(data.google_projects.all_projects.projects,count.index).project_id
  service = "serviceusage.googleapis.com"

  disable_on_destroy = true
}

resource "google_project_service" "cloudfilestore_api" {
  count = var.d9_gcp_api_enabler.cloudfilestore_api ? length(data.google_projects.all_projects.projects[*].project_id) : 0
  project = element(data.google_projects.all_projects.projects,count.index).project_id
  service = "file.googleapis.com"

  disable_on_destroy = true
}

resource "google_project_service" "apikeys_api" {
  count = var.d9_gcp_api_enabler.apikeys_api ? length(data.google_projects.all_projects.projects[*].project_id) : 0
  project = element(data.google_projects.all_projects.projects,count.index).project_id
  service = "apikeys.googleapis.com"

  disable_on_destroy = true
}

resource "google_project_service" "cloudlogging_api" {
  count = var.d9_gcp_api_enabler.cloudlogging_api ? length(data.google_projects.all_projects.projects[*].project_id) : 0
  project = element(data.google_projects.all_projects.projects,count.index).project_id
  service = "logging.googleapis.com"

  disable_on_destroy = true
}

resource "google_project_service" "clouddns_api" {
  count = var.d9_gcp_api_enabler.clouddns_api ? length(data.google_projects.all_projects.projects[*].project_id) : 0
  project = element(data.google_projects.all_projects.projects,count.index).project_id
  service = "dns.googleapis.com"

  disable_on_destroy = true
}

resource "google_project_service" "cloudasset_api" {
  count = var.d9_gcp_api_enabler.cloudasset_api ? length(data.google_projects.all_projects.projects[*].project_id) : 0
  project = element(data.google_projects.all_projects.projects,count.index).project_id
  service = "cloudasset.googleapis.com"

  disable_on_destroy = true
}

resource "google_project_service" "esscontracts_api" {
  count = var.d9_gcp_api_enabler.esscontracts_api ? length(data.google_projects.all_projects.projects[*].project_id) : 0
  project = element(data.google_projects.all_projects.projects,count.index).project_id
  service = "essentialcontacts.googleapis.com"

  disable_on_destroy = true
}

resource "google_project_service" "accessapp_api" {
  count = var.d9_gcp_api_enabler.accessapp_api ? length(data.google_projects.all_projects.projects[*].project_id) : 0
  project = element(data.google_projects.all_projects.projects,count.index).project_id
  service = "accessapproval.googleapis.com"

  disable_on_destroy = true
}

resource "google_service_account" "d9sa"{
  account_id = var.d9_SA_Ac
  display_name = "Dome9 onboarding account"
  project = "ferrous-cogency-426918-s0"
}

resource "google_project_iam_binding" "binding_dome9_reader"{
  project = "ferrous-cogency-426918-s0"
  role = "roles/viewer"

  members = [
    "serviceAccount:${google_service_account.d9sa.email}"
  ]
}

resource "google_service_account_key" "d9key"{
  service_account_id = google_service_account.d9sa.name
  public_key_type = "TYPE_X509_PEM_FILE"
}

#resource "google_service_account_iam_member" "dome9reader"{
#  service_account_id = google_service_account.d9sa.name
#  role = "roles/viewer"
#  member = "serviceAccount:${google_service_account.d9sa.email}"
#}
