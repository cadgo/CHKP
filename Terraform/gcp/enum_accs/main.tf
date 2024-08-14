provider "google" {
  credentials = file("~/.secrets_cdz/key.json")
}

resource "google_service_account" "d9sa"{
  account_id = var.d9_SA_Ac
  display_name = "Dome9 onboarding account"
  project = var.gcp_main_project
}

resource "google_project_iam_binding" "main_binding_permissions_cspm"{
  for_each = toset(var.gcp_permissions)
  project = var.gcp_main_project
  role = each.value

  members = [
    "serviceAccount:${google_service_account.d9sa.email}"
  ]
}

resource "google_service_account_key" "d9key"{
  service_account_id = google_service_account.d9sa.name
  public_key_type = "TYPE_X509_PEM_FILE"
}

resource "local_file" "keystorage"{
  content = base64decode(google_service_account_key.d9key.private_key)
  filename = "gcpkey.key"
}

#resource "google_service_account_iam_member" "dome9reader"{
#  service_account_id = google_service_account.d9sa.name
#  role = "roles/viewer"
#  member = "serviceAccount:${google_service_account.d9sa.email}"
#}
