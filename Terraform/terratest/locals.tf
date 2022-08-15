locals {
  var1 = {
    Networks = {
     "vpc_0" = {
        vpc_ip = "10.0.0.0/16" 
        private_sub = ["10.0.0.0/24", "10.0.1.0/24"]
        public_sub = ["10.0.2.0/24", "10.0.3.0/24"]
      }
      "vpc_1" = {
        vpc_ip = "192.168.0.0/16" 
        private_sub = ["192.168.0.0/24", "192.168.1.0/24"]
        public_sub = ["192.168.2.0/24", "192.168.3.0/24"]
      }
    }
  }
  var2  = {
    slo_groups = {
      "group1" = {sev = ["10", "20", "30"], group = "group1"}
    }
  }
  vpc_list = [for i in local.var1.Networks: i.vpc_ip]
}
