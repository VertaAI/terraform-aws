# Verta's Terraform module for AWS
This module contains the necessary code to create an IAM role in your account with the required permission for Verta to manage your whole infrastructure. Note that the role created has the minimal permission possible for the functionality provided, following the principle of least privilege.

## Variables
- `cluster_name [string]`: name of the cluster as assigned to the customer by Verta.
- `role_name [string]`: name of the IAM role to be created in the user's account.

## Usage
To use this module, create a Terraform package containing
```
module "role_module" {
 source  = "git@github.com:VertaAI/terraform-aws?ref=VERSION"

 cluster_name = "example"
 role_name = "vertaai-ops"
}

output "role_arn" {
  description = "ARN of Verta IAM role"
  value       = module.role_module.role_arn
}
```
where `VERSION` is the desired version of the module (we use tags for semantic versioning).

Note that the user is responsible for configuring the provider and state, if any.

## Providing the role to Verta
After you have applied the change to your environment with `terraform apply`, you should provide the value of the output `role_arn` to your Verta representative. If you have missed that value, you can run `terraform output` in your folder to fetch that value again.

## CloudFormation support
We also provide a file `role-cloudformation.yaml` in the repository so that you can use CloudFormation to manage your infrastructure. However, due to limitations on CloudFormation templating, you have to manually replace the term `CLUSTER_NAME` with the name that Verta provides you. This makes sure that the permissions are set up correctly for the role. You should share the resulting role ARN with Verta so that we can manage your setup.
