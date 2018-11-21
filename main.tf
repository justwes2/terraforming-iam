resource "aws_iam_policy" "policy" {
  name        = "deny_network_changes"
  path        = "/"
  description = "prevents unauthorized network changes"

  policy = "${file("./policies/deny_network_changes.json")}"
}
# Can use templates to interpolate resource specific arns