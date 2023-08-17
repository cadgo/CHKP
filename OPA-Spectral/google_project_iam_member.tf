#google_project_iam_member should not have member contain-any [($ like '%group%')] or member contain-any [($ like '%user%')]  and role contain-any [($ like #'%roles/iam.serviceAccountUser%')]
#
resource "google_project_iam_member" "project" {
  project = "your-project-id"
  role    = "roles/iam.serviceAccountUser.test"
  member  = "group:jane@example.com"

  condition {
    title       = "expires_after_2019_12_31"
    description = "Expiring at midnight of 2019-12-31"
    expression  = "request.time < timestamp(\"2020-01-01T00:00:00Z\")"
  }
}
