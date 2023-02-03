output "subnet_id" {
    description = "subnet id"
    value = { for k, sn in aws_subnet.dev: k => sn.id }
}
