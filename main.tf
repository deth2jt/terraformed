provider "aws" {
	region = "us-east-1"
}


module "vpc" {
	source = "./vpc"
	vpc_cidr = "10.0.0.0/16"
	public_cidrs = ["10.0.0.0/24", "10.0.2.0/24"]
	private_cidrs = ["10.0.1.0/24", "10.0.3.0/24"]
	transit_gateway = "${module.transit_gateway.transit_gateway}"
}

module "ec2" {
	source = "./ec2"
	my_public_key = "/Users/jthompson/.ssh/test_rsa.pub"
	instance_type = "t2.micro"
	security_group = "${module.vpc.security_group}"
	subnets = "${module.vpc.public_subnets}"
}

module "transit_gateway" {
	source = "./transit_gateway"
	vpc_id = "${module.vpc.vpc_id}"
	public_subnet1 = "${module.vpc.public_subnet1}"
	public_subnet2 = "${module.vpc.public_subnet2}"
}