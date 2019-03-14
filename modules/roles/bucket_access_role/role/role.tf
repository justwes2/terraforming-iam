provider "aws" {
  profile = "${var.profile}"
  region = "${var.region}"
}
data "aws_iam_policy_document" "instance-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      indentifiers = ["ec2.amazonaws.com"]
    }
  }
}
data "aws_caller_identity" "current" {}
resource "aws_iam_role" "role" {
  name = "${var.name}"
  description = "${var.description}"
  assume_role_policy = "${data.aws_iam_policy_document.instance-assume-role-policy.json}"
}

resource "aws_iam_instance_profile" "role_profile" {
  name = "${aws_iam_role.role.name}"
  role = "${aws_iam_role.role.name}"
}

resource "aws_iam_role_policy_attachment" "policy_1" {
  role = "${aws_iam_role.role.name}"
  policy_arn = "arn:aws(-us-gov):iam::aws:policy/${var.policies[0]}"
}
