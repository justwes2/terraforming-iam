variable "profile" {
  description = "The name of the aws profile/keys to be used"
  default = "default"
}

variable "name" {
  description = "The name of the policy"
}
variable "description" {
  description = "The description of the policy"
}
variable "policy" {
  description = "the name of the json policy file (omit .json)"
}
