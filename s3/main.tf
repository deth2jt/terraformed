provider "aws" {
	region = "us-east-1"
}

resource "random_id" "my-random-id" {
    byte_length = 2
}

resource "aws_s3_bucket" "my-foo-bucket" {
    bucket = "${var.s3_buck_name}-${random_id.my-random-id.dec}"
    acl = "private"

    versioning {
        enabled = true
    }

    lifecycle_rule {
        enabled = true

        transition {
            storage_class = "STANDARD_IA"
            days = 30
        }
    }

    tags = {
        Name = "foo-s3-tagged"
    }

}