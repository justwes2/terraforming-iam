## Terraforming IAM Policies, Groups, and Roles

One of the challenges of cloud governace in the hub and spoke model is ensuring consistantcy of rights across all environments. Like all cloud infrastructure, there are a number of tools for managing infrastructure as code. This framework allows users to manage access using Terraform. For more information about Terraform, see the docs[https://terraform.com/docs]. 
Using nested modules, this framework calls for the creation of the same IAM resources in multiple AWS accounts. 

### Adding an account

Currently, the framework pulls AWS keys from the `.aws/credentials` file. Users can add profiles for multiple accounts using the AWS CLI `aws configure --profile <NAME>` command TODO (link[url]). As long as profile names are coordinated across the governance envornment, multiple users can modify the framework. It also supports integration into a CI/CD pipeline such as Jeinkins for automated update of resoures.
To add an account, add the following block to *ALL* `accounts.tf` files:

```
module "<PROFILE NAME>" {
    ...
    profile = "<PROFILE NAME>"
    ...
}
```
Note that various `accounts.tf` will have unique sources and variables. Defer to the default profile to ensure the correct arguments are passed to the second tier module.


### Creating a policy

All policies are expressed in standard AWS json. For users who are not comfortable writing these policies freehand, AWS's IAM policy generator creates a json statement based on GUI input that can be copied into a `.json` file. All policy documents should be placed in the `modules/policy` directory. Then, in the `main.tf`, add a module:
```
module "<NAME OF POLICY>" {
    source = "./modules/accounts"
    name = "<NAME OF POLICY>"
    desciption = "<DESCRIPTION OF POLICY>"
    policy = "<NAME OF POLICY>.json"
}
```
Replace the name and description. Run `terraform apply`. The command should create a resouce for each account listed.

### Conclusion
terraform vs cf vs boto3

# TODO add ex for e2 -> bucket