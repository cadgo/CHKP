variable "kubernetes_enabler"{
  type = map
  description = "define if Kubernetes must be enable in all projects"
  default = {
    k8s = true
  }
}

variable "kms_enabler"{
  type = map
  descirption = "define if kms must be enable in all projects"
  default = {
    kms = true
  }
}

variable "iam_enabler"{
  type = map
  description = "define if iam must be enable in all projects"
  default = {
    iam = true
  }
}

variable "appengine_enabler"{
  type = map
  descirption = "define if appengine must be enable in all projects"
  default = {
    appeng = true
  }
}

variable "bigquery_enabler"{
  type = map
  description = "define if bigquery must be enable in all projects"
  default = {
    bigq = true
  }
}

variable "adminsdk_enabler"{
  type = map
  description = "define if admin sdk must be enable in all projects"
  default = {
    adm_sdk = true
  }
}

variable "cloudfuncapi_enabler"{
  type = map
  description = "define if cloudfuncapi  must be enable in all projects"
  default = {
    cloudfunc = true
  }
}

variable "cloudsqladmin_enabler"{
  type = map
  description = "define if cloudsqladmin  must be enable in all projects"
  default = {
    cloudsql = true
  }
}

variable "cloudbigtable_enabler"{
  type = map
  description = "define if cloudbigtabler must be enable in all projects"
  default = {
    cloudbigt = true
  }
}

variable "pubsub_enabler"{
  type = map
  description = "define if pubsub must be enable in all projects"
  default = {
    pubsub = true
  }
}

variable "cloudmemorystore_enabler"{
  type = map
  description = "define if cloudmemorystore sdk must be enable in all projects"
  default = {
    mem_store = true
  }
}

variable "serviceusage_enabler"{
  type = map
  description = "define if serviceusage must be enable in all projects"
  default = {
    serv_usage = true
  }
}

variable "cloudfilestore_enabler"{
  type = map
  description = "define if cloudfilestore must be enable in all projects"
  default = {
    cloudfile = true
  }
}

variable "apikeys_enabler"{
  type = map
  description = "define if apikeys must be enable in all projects"
  default = {
    apikeys = true
  }
}

variable "cloudlogging_enabler"{
  type = map
  description = "define if cloudlogging must be enable in all projects"
  default = {
    cloud_log = true
  }
}

variable "clouddns_enabler"{
  type = map
  description = "define if clouddns must be enable in all projects"
  default = {
    cloud_dns = true
  }
}

variable "cloudasset_enabler"{
  type = map
  description = "define if cloudasset must be enable in all projects"
  default = {
    cloud_asset = true
  }
}

variable "essentialcontracts_enabler"{
  type = map
  description = "define if essentialcontracts must be enable in all projects"
  default = {
    ess_cont = true
  }
}

variable "accessapporval_enabler"{
  type = map
  description = "define if accessapporval must be enable in all projects"
  default = {
    acc_app = true
  }
}
