variable "profile" {
  description = "CLI profile to use"
  default = "default"
}
variable "aws_region" {
  description = "IAM is global, so not relevant, but must be included for terraform"
  default = "us-east-4"
}
variable "name" {}
variable "description" {}
variable "policy" {}

