  variable "d9_gcp_api_enabler"{
    type = map
    description = "API required by DOME9 on GCP, https://sc1.checkpoint.com/documents/CloudGuard_Dome9/Documentation/Getting-Started/Onboarding-single-GCP-project.htm"
    default = {
      k8s_api = true
      kms_api = true
      iam_api = true
      appeng_api = true
      bigquery_api = true
      admsdk_api = true
      cloudfunc_api = true
      cloudsql_api = true
      cloudbigtable_api = true
      pubsub_api = true
      cloudmem_api = true
      servusage_api = true
      cloudfilestore_api = true
      apikeys_api = true
      cloudlogging_api = true
      clouddns_api = true
      cloudasset_api = true
      esscontracts_api = true
      accessapp_api = false
    }
  }


variable "d9_SA_Ac"{
  type = string
  description = "Service account used for D9 for GCP enrollment"
  default = "d9onboard"
}
