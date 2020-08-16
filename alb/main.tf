provider "aws" {
	region = "us-east-1"
}

resource "aws_lb_target_group" "my-target-group" {
    health_check {
        interval = 10
        path = "/"
        protocol = "HTTP"
        timeout = 5
        healthy_threshold = 5
        unhealthy_threshold = 2
    }

    name = "my-foo-tg"
    port = 80
    protocol = "HTTP"
    target_type = "instance"
    vpc_id = "${var.vpc_id}"
}

/*
#take since using auto scaling
resource "aws_lb_target_group_attachment" "my-alb-target-group-attachemnt1" {
    target_group_arn = "${aws_lb_target_group.my-target-group.arn}"
    target_id = "${var.instance_id}"
    port = 80
}

resource "aws_lb_target_group_attachment" "my-alb-target-group-attachemnt2" {
    target_group_arn = "${aws_lb_target_group.my-target-group.arn}"
    target_id = "${var.instance_id2}"
    port = 80
}
*/


resource "aws_security_group" "my-alb-sg" {
    name = "my-alb-sg"
    vpc_id = "${var.vpc_id}"
}

resource "aws_security_group_rule" "inbound_ssh" {
    from_port = 22
    protocol = "tcp"
    security_group_id = "${aws_security_group.my-alb-sg.id}"
    to_port = 22
    type = "ingress"
    cidr_blocks = ["0.0.0.0/0"]
}


resource "aws_security_group_rule" "inbound_http" {
    from_port = 80
    protocol = "tcp"
    security_group_id = "${aws_security_group.my-alb-sg.id}"
    to_port = 80
    type = "ingress"
    cidr_blocks = ["0.0.0.0/0"]
}


resource "aws_security_group_rule" "outbound_all" {
    from_port = 0
    protocol = "-1"
    security_group_id = "${aws_security_group.my-alb-sg.id}"
    to_port = 0
    type = "egress"
    cidr_blocks = ["0.0.0.0/0"]
}



resource "aws_lb" "my-aws-alb" {
    name = "my-foo-alb"
    internal = false

    security_groups = [
        "${aws_security_group.my-alb-sg.id}"
    ]

    subnets = [
        "${var.subnet1}",
        "${var.subnet2}"
    ]

    tags = {
        Name = "my-test-alb"
    }

    ip_address_type = "ipv4"
    load_balancer_type = "application"
}


resource "aws_lb_listener" "my-foo-alb-listener" {
    load_balancer_arn = "${aws_lb.my-aws-alb.arn}"
    port = 80
    protocol = "HTTP"

    default_action  {
        type = "forward"
        target_group_arn = "${aws_lb_target_group.my-target-group.arn}"
    }
}

