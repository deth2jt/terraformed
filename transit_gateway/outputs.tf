output "transit_gateway" {
    value = "${ aws_ec2_transit_gateway.my-foo-tgw.id}"
}