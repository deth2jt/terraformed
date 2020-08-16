provider "aws" {
	region = "us-east-1"
}

resource "aws_route53_zone" "my-foo-zone" {
    name = "example.com"
    vpc {
        vpc_id = "${var.vpc_id}"
    }
}

#The index is zero-based. This function produces an error if used with an empty list.
resource "aws_route53_record" "my-foo-record" {
    count = "${length(var.hostname)}"
    name = "${var.hostname[count.index]}"
    #name = "{element(var.hostname, count.index)}"
    records = ["${element(var.arecord,count.index)}"]
    zone_id = "${aws_route53_zone.my-foo-zone.id}"
    type = "A"
    ttl = "300"
}

