provider "aws" {
  region = "us-east-1"
  #version = "1.40.0"
}


module "vpc" {
  source          = "./vpc"
  vpc_cidr        = "10.0.0.0/16"
  public_cidrs    = ["10.0.0.0/24", "10.0.2.0/24"]
  private_cidrs   = ["10.0.1.0/24", "10.0.3.0/24"]
  transit_gateway = "${module.transit_gateway.transit_gateway}"
}

module "ec2" {
  source         = "./ec2"
  my_public_key  = "/Users/jthompson/.ssh/test_rsa.pub"
  instance_type  = "t2.micro"
  security_group = "${module.vpc.security_group}"
  subnets        = "${module.vpc.public_subnets}"
}

module "transit_gateway" {
  source         = "./transit_gateway"
  vpc_id         = "${module.vpc.vpc_id}"
  public_subnet1 = "${module.vpc.public_subnet1}"
  public_subnet2 = "${module.vpc.public_subnet2}"
}


module "alb" {
  source       = "./alb"
  vpc_id       = "${module.vpc.vpc_id}"
  instance_id  = "${module.ec2.instance_id}"
  instance_id2 = "${module.ec2.instance_id2}"
  subnet1      = "${module.vpc.public_subnet1}"
  subnet2      = "${module.vpc.public_subnet2}"
}


module "auto_scaling" {
  source           = "./auto_scaling"
  vpc_id           = "${module.vpc.vpc_id}"
  subnet1          = "${module.vpc.public_subnet1}"
  subnet2          = "${module.vpc.public_subnet2}"
  pub_key          = "${module.ec2.myfoo-key}"
  target_group_arn = "${module.alb.alb_target_group_arn}"
}

module "sns_topic" {
  source       = "./sns_topic"
  alarms_email = "me@jeromeothompson.com"
}


module "cloud_watch" {
  source       = "./cloudwatch"
  sns_topic1   = "${module.sns_topic.sns_arn}"
  instance_id2 = "${module.ec2.instance_id2}"
  instance_id  = "${module.ec2.instance_id}"
}

module "rds" {
  source      = "./rds"
  db_instance = "db.t2.micro"
  rds_subnet1 = "${module.vpc.private_subnet1}"
  rds_subnet2 = "${module.vpc.private_subnet2}"
  vpc_id      = "${module.vpc.vpc_id}"
}


module "route53" {
  source   = "./route53"
  hostname = ["test1", "test2"]
  arecord  = ["10.0.1.11", "10.0.1.12"]
  vpc_id   = "${module.vpc.vpc_id}"
}


module "iam" {
  source   = "./iam"
  username = ["foobar", "helloworld", "ipsolem"]
}

module "s3" {
  	source       = "./s3"
  	s3_buck_name = "foobar-bucket"
}


module "cloudtrail" {
	source          = "./cloudtrail"
	cloudtrail_name = "my-foo-cloudtrail"
	s3_bucket_name  = "s3-cloudtrail-bucket-tf"
}


module "kms" {
	source = "./kms"
	user_name = "${module.iam.aws_iam_user}"
}

module "vpc_endpoint_logs" {
	source = "./vpc_endpoint_logs"
	vpc_id   = "${module.vpc.vpc_id}"
	private_subnet1 = "${module.vpc.private_subnet1}"
  	private_subnet2 = "${module.vpc.private_subnet2}"
	security_group = "${module.vpc.security_group}"
}

module "vpc_endpoint_s3" {
	source = "./vpc_endpoint_s3"
	vpc_id   = "${module.vpc.vpc_id}"
	route_table = "${module.vpc.default_route_table}"
}