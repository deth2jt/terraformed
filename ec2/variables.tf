variable "my_public_key" {}

variable "instance_type" {}

variable "security_group" {
    #type = string
    description = "(optional) describe your variable"
}

variable "subnets" {
    type = "list"
}

