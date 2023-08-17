#google_project_iam_binding should not have role='roles/owner' or role='roles/editor'

resource "google_project_iam_binding" "projectA" {
  project = "your-project-id"
  role    = "roles/owner"

  members = [
    "user:jane@example.com",
  ]

  condition {
    title       = "expires_after_2019_12_31"
    description = "Expiring at midnight of 2019-12-31"
    expression  = "request.time < timestamp(\"2020-01-01T00:00:00Z\")"
  }
}
resource "google_project_iam_binding" "projectB" {
  project = "your-project-id"
  role    = "roles/editor"

  members = [
    "user:jane@example.com",
  ]

  condition {
    title       = "expires_after_2019_12_31"
    description = "Expiring at midnight of 2019-12-31"
    expression  = "request.time < timestamp(\"2020-01-01T00:00:00Z\")"
  }
}

#google_project_iam_binding should not have member contain-any [($ like '%group%')] or member contain-any [($ like '%user%')] or member contain-any [($ like '%serviceAccount%')] or #member contain-any [($ like '%domain%')] or members contain-any [($ like '%group%')] or members contain-any [($ like '%user%')] or members contain-any [($ like '%serviceAccount%')] #or members contain-any [($ like '%domain%')]
