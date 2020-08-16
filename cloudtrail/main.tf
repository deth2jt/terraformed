provider "aws" {
	region = "us-east-1"
	#version = "1.40.0"
}

resource "aws_cloudtrail" "my-foo-cloudtrail" {
    name = "${var.cloudtrail_name}"
    s3_bucket_name = "${aws_s3_bucket.s3_bucket_name.id}"
    include_global_service_events = true
    is_multi_region_trail = true
    enable_log_file_validation = true
}

resource "aws_s3_bucket" "s3_bucket_name" {
    bucket = "${var.s3_bucket_name}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
{
   "Sid": "AWSCloudTrailAclCheck",
   "Effect": "Allow",
   "Principal": {
      "Service": "cloudtrail.amazonaws.com"
},
 "Action": "s3:GetBucketAcl",
 "Resource": "arn:aws:s3:::s3-cloudtrail-bucket-tf"
},
{
"Sid": "AWSCloudTrailWrite",
"Effect": "Allow",
"Principal": {
  "Service": "cloudtrail.amazonaws.com"
},
"Action": "s3:PutObject",
"Resource": "arn:aws:s3:::s3-cloudtrail-bucket-tf/*",
"Condition": {
  "StringEquals": {
     "s3:x-amz-acl": "bucket-owner-full-control"
  }
}
  }
  ]
  }
  POLICY
}    