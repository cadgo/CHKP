locals {
  apis_modified = {for api,status in var.d9_gcp_api_enabler : api => status if status==true}
}
