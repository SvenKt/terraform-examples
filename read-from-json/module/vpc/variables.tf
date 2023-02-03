variable "vpc_data" {
    type = map(any)
    default = {
      namespace = "test"
      cidr = "NONE"
    }
}