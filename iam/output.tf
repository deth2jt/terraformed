output "aws_iam_user" {
    value = "${aws_iam_user.my-foo-user.0.arn}"
}