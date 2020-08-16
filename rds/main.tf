provider "aws" {
	region = "us-east-1"
}

resource "aws_db_instance" "my-foo-sql" {
    instance_class = "${var.db_instance}"
    engine = "mysql"
    engine_version = "5.7"
    multi_az = true
    storage_type = "gp2"
    allocated_storage = 20
    name = "myfoords"
    username = "fooadmin"
    password = "foobar-!123"
    apply_immediately = "true"
    backup_retention_period = 10
    backup_window = "09:45-10:30"
    db_subnet_group_name = "${aws_db_subnet_group.my-rds-db-subnet.name}"
    vpc_security_group_ids = ["${aws_security_group.my-rds-sg.id}"]
}


resource "aws_db_subnet_group" "my-rds-db-subnet" {
    name = "my-rds-db-subnet"
    subnet_ids = ["${var.rds_subnet1}", "${var.rds_subnet2}"]
}

resource "aws_security_group" "my-rds-sg" {
    name = "my-rds-sg"
    vpc_id = "${var.vpc_id}"
}


resource "aws_security_group_rule" "my-rds-sg-rule1" {
    from_port = 3306
    protocol = "tcp"
    security_group_id = "${aws_security_group.my-rds-sg.id}"
    to_port = 3306
    type = "ingress"
    cidr_blocks = ["0.0.0.0/0"]
}


resource "aws_security_group_rule" "my-rds-sg-rule2" {
    from_port = 0
    protocol = "-1"
    security_group_id = "${aws_security_group.my-rds-sg.id}"
    to_port = 0
    type = "egress"
    cidr_blocks = ["0.0.0.0/0"]
}
