output "vpc" {
    description = "vpc id"
    value = aws_vpc.vpc_dev.id
}


output "route_table_id" {
    description = "rt id"
    value = aws_route_table.rt_dev.id
}