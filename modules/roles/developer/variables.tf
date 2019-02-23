variable "name" {
  description = "Name of role"
}
variable "description" {
  description = "Description of role"
}
variable "policies" {
  type = "list"
  description = "List of policies attached to role"
}


