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
        "Federated": "arn:aws(-us-gov):iam::${data.aws_caller_identity.current.account_id}:saml-provider/MyOrgsSamlProvider"
    },
    "Action": "sts:AssumeRoleWithSAML",
    "Condition": {
      "StringEquals": {
        "SAML:aud": "URL_OF_SAML_PROVIDER"
      }
    }
  }
]
}
  POLICY
}

resource "aws_iam_role_policy_attachment" "policy_1" {
  role = "${aws_iam_role.role.name}"
  policy_arn = "arn:aws(-us-gov):iam::aws:policy/${var.policies[0]}"
}
resource "aws_iam_role_policy_attachment" "policy_2" {
  role = "${aws_iam_role.role.name}"
  policy_arn = "arn:aws(-us-gov):iam::${data.aws_caller_identity.current.account_id}:policy/${var.policies[1]}"
}
resource "aws_iam_group" "group" {
  name = "${var.name}"
}

resource "aws_iam_group_policy_attachment" "policy_1" {
  group = "${aws_iam_group.group.name}"
  policy_arn = "arn:aws(-us-gov):iam::aws:policy/${var.policies[0]}"
}
resource "aws_iam_group_policy_attachment" "policy_2" {
  group = "${aws_iam_group.group.name}"
  policy_arn = "arn:aws(-us-gov):iam::${data.aws_caller_identity.current.account_id}:policy/${var.policies[1]}"
}
