provider "aws" {
  profile = "${var.profile}"
  region = "${var.aws_region}"
}
locals {
  filepath = "${path.module}/${var.policy}"
}
resource "aws_iam_policy" "policy" {
  name        = "${var.name}"
  description = "Managed by terraform- do not modify. ${var.description}"
  policy = "${file("${local.filepath}")}"
}
