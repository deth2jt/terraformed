output "instance_id" {
    value = "${element(aws_instance.my-foo-instance.*.id, 1)}"
}


output "instance_id2" {
    value = "${element(aws_instance.my-foo-instance.*.id, 2)}"
}

output "myfoo-key" {
  value = "${aws_key_pair.myfoo-key.id}"
}