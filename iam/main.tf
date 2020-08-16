provider "aws" {
	region = "us-east-1"
}

resource "aws_iam_user" "my-foo-user" {
    name = "${element(var.username, count.index)}"
    count = "${length(var.username)}"
}

resource "aws_iam_role" "my-foo-iam-role" {
    name = "my-foo-iam-role"

  assume_role_policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
{
"Action": "sts:AssumeRole",
"Principal": {
 "Service": "ec2.amazonaws.com"
},
"Effect": "Allow"
}
]
}
EOF

    tags = {
        tag-key = "my-foo-iam-role"
    }
}


resource "aws_iam_role_policy" "my-foo-policy" {
    name = "my-foo-iam-policy"
    role = "${aws_iam_role.my-foo-iam-role.id}"


  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "cloudwatch:PutMetricData",
                "ec2:DescribeTags",
                "logs:PutLogEvents",
                "logs:DescribeLogStreams",
                "logs:DescribeLogGroups",
                "logs:CreateLogStream",
                "logs:CreateLogGroup"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_instance_profile" "my-foo-iam-instance-profile" {
    name = "my-foo-iam-instance-profile"
    role = "${aws_iam_role.my-foo-iam-role.id}"
}

