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
