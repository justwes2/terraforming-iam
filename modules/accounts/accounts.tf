module "default" {
    source = "../policy"
    profile = "default"
    name = "${var.name}"
    description = "${var.description}"
    policy = "${var.policy}"
}