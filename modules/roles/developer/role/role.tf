provider "aws" {
  profile = "${var.profile}"
  region = "${var.region}"
}
data "aws_caller_identity" "current" {}
resource "aws_iam_role" "role" {
  name = "${var.name}"
  description = "${var.description}"
  assume_role_policy = <<POLICY
{
    "Version": "2012-10-17",
"Statement": [
    "Effect": "Allow",
    "Prinicpal: {
        
    }"
]
}
}
