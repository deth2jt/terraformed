provider "aws" {
	region = "us-east-1"
}

data "aws_availability_zones" "available" {}

data "aws_ami" "centos" {
#data "aws_ami" "redhat" {
    owners = ["679593333241"]
    most_recent = true
    #https://stackoverflow.com/questions/40835953/how-to-find-ami-id-of-centos-7-image-in-aws-marketplace
    #https://wiki.centos.org/Cloud/AWS
    filter {
        name   = "name"
        values = ["CentOS Linux 7 *"]
        #values = ["RHEL-7.5_HVM_GA-20180322-x86_64-1-Hourly2-GP2"]
    }

    filter {
        name   = "architecture"
        values = ["x86_64"]
    }

    filter {
        name   = "root-device-type"
        values = ["ebs"]
    }
}

resource "aws_key_pair" "myfoo-key" {
    key_name = "my-foo-terraform-key-new"
    public_key = "${file(var.my_public_key)}"
}

data "template_file" "init" {
    template = "${file("${path.module}/userdata.tpl")}"

}

resource "aws_instance" "my-foo-instance" {
    count = 2
    ami = "ami-02354e95b39ca8dec"
    #ami = "${data.aws_ami.centos.id}"
    instance_type = "${var.instance_type}"
    key_name = "${aws_key_pair.myfoo-key.id}"
    vpc_security_group_ids = ["${var.security_group}"]
    subnet_id = "${element(var.subnets, count.index)}"
    user_data = "${data.template_file.init.rendered}"

    tags = {
        Name = "my-instance-${count.index + 1}"
    }
}

resource "aws_ebs_volume" "my-foo-ebs" {
    count = 2
    availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
    size = 2
    type = "gp2"
}


resource "aws_volume_attachment" "my-vol-attch" {
    count = 2
    device_name = "/dev/xvdh"
    instance_id = "${aws_instance.my-foo-instance.*.id[count.index]}"
    volume_id = "${aws_ebs_volume.my-foo-ebs.*.id[count.index]}"
    force_detach = true
}