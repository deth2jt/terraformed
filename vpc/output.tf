output "public_subnets" {
  value = "${aws_subnet.public_subnet.*.id}"
}

output "security_group" {
  value = "${aws_security_group.foo_sg.id}"
}

output "vpc_id" {
  value = "${aws_vpc.main.id}"
}

output "public_subnet1" {
  value = "${element(aws_subnet.public_subnet.*.id, 1 )}"
}

output "public_subnet2" {
  value = "${element(aws_subnet.public_subnet.*.id, 2 )}"
}

output "private_subnet1" {
  value = "${element(aws_subnet.private_subnet.*.id, 1 )}"
}

output "private_subnet2" {
  value = "${element(aws_subnet.private_subnet.*.id, 2 )}"
}

output "default_route_table" {
  value = "${aws_default_route_table.public_route.id}"
}