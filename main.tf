terraform {
    backend "s3" {
        bucket = "<BUCKET NAME HERE>"
        key = "main"
        region = "us-east-4"
        profile = "default"
    }
}

module "deny_networking" {
    source = "./modules/accounts"
    name = "deny_networking"
    desciption = "Prevents unauthorized changes to network configuration"
    policy = "deny_network_changes.json"
}
module "bucket_access_policy" {
  source = "./modules/acounts"
  name = "bucket_access_policy"
  description = "Ec2 role for access to specific buckets"
  policy = "bucket_policy.json"
}

module "developer_role" {
    source = "./modules/roles/developer"
    name = "Developer"
    description = "Role of accessing ec2 resources"
    policies = [
        "AmazonEC2FullAccess",
        "${module.deny_networking.name}"
    ]
}
module "bucket_access_role" {
    source = "./modules/roles/bucket_access"
    name = "bucket_access_role"
    desciption = "role to access specific bucket"
    policies = ["${module.bucket_access_policy.name}"]
}