variable "subnets" {
  type = map(object({
    cidr = string
    az = string
    ns = string
  }))
  default = {
    "subnet1" = {
      cidr = "NONE"
      az = "NONE"
      ns = "test"
    }
  }
}


variable "vpc_id" {
  default = "NONE"
}

variable route_table {
  default = "NONE"
}