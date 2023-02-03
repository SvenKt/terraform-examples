locals {
  config = jsondecode(file("./files/general.json"))
}

provider "aws" {
  profile = local.config.base-info.aws-profile
  region = local.config.base-info.aws-region
}

module "my_vpc" {
 source = "./module/vpc"
 vpc_data = local.config.vpc
}


module "my-networks" {
    source = "./module/networks"
    subnets = local.config.subnets

    vpc_id = module.my_vpc.vpc
    route_table = module.my_vpc.route_table_id
}

output "subnets" {
  description = "subnet ids"
  value       = module.my-networks.subnet_id
}

