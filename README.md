# Terraforming IAM Policies, Groups, and Roles

One of the challenges of cloud governace in the hub and spoke model is ensuring consistantcy of rights across all environments. Like all cloud infrastructure, there are a number of tools for managing infrastructure as code. This framework allows users to manage access using Terraform. For more information about Terraform, see the [docs](https://www.terraform.io/docs/index.html). 
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

### Creating a Role/Group

In many environments, SAML-based federated access is how users authenticated into the AWS Console. However, AWS does not have a mechanism to support CLI authentication in a SAML/Active Directory federation scheme. Therefore, creating groups and roles with identical policies ensure that user keys and console permissions will be identitical. 
Because of the limitations of Terraform (see conclusion), each role/group must have its own directory in `/modules/roles`. The role directory should look like this:
```
<ROLE NAME>
    - role
        - role.tf
        - variables.tf
    - accounts.tf
    - variables.tf
```

The `accounts.tf` should list all accounts in the envornment. See 'Adding an Account' above. The `role/role.tf` will need to be updated. Ensure that the role is configured to the SAML provider correctly- the specific configuration will vary by implementation, and is out of scope. A boilerplate is included in the example developer role. 
Ensure that a TODO `group policy attachment` and a `role policy attachement` resource is created for each policy to be attached to the role/group. Note that policies managed by AWS will have `aws` in the ARN. For custom policies, use the `data.aws_caller_identity.current` resource. This resource is compliled into the account number where the policy is deployed.
Finally, add a module to the `main.tf` like so:
```
module "<ROLE NAME>" {
    source = "./modules/roles/<ROLE NAME>"
    name = "<ROLE NAME>"
    desciption = "<ROLE DESCRIPTION>"
    policies = "[COMMA SEPARATED LIST OF POLICIES]"
}
```
Any policies that are managed by this framework should be referenced by calling the module like so: `module.<POLICY NAME>.name`. Calling it by name can lead to compile time errors. 

### EC2 Role
There is a role `bucket_access_role` listed as well. This creates a role which can be attached to an ec2 instanct that allows access to the contents of the S3 bucket specificed in the policy. Note that the `aws_iam_instance_profile` needs to be created to allow the role to be attached. 

### Conclusion
The advantages of Infrastructrue as Code (Repeatablity, Transparency, Auditablity) are just as applicable to Identity and Access Managment as to more traditonally defined infrastructure (compute, networking, storage). This framework was writtern for Terraform over Cloudformation. In a multi-cloud organization, a cloud agnositic tool like terraform can reduce complexity over a CSP specific tool like Cloudformation. 

