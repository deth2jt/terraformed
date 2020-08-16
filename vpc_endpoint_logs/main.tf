resource "aws_vpc_endpoint" "ec2log" {
    vpc_id = "${var.vpc_id}"
    service_name = "com.amazonaws.us-east-1.logs"
    subnet_ids = ["${var.private_subnet1}", "${var.private_subnet2}"]

    vpc_endpoint_type = "Interface"


    security_group_ids = [
        "${var.security_group}"
    ]

     policy = <<POLICY
{
    "Statement": [
        {
            "Action": "*",
            "Effect": "Allow",
            "Resource": "*",
            "Principal": "*"
        }
    ]
}
POLICY

    private_dns_enabled = true
}


