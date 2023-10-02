# TF-octopus
AWS VPC and Subnets Terraform Project
This Terraform project deploys an Amazon Web Services (AWS) Virtual Private Cloud (VPC) with subnets in the us-west-1 region. It's designed for learning Terraform and demonstrates how to create networking resources in AWS.

## Table of Contents
- Prerequisites
- Getting Started
- Project Structure
- Variables
- Resources
- Outputs
- Terraform Commands

###Prerequisites
Before you begin, ensure you have the following prerequisites:

- Terraform installed on your local machine.
- AWS credentials configured with the necessary permissions. These credentials should be set up in your ~/.aws/credentials file.
### Getting Started
1. Clone this repository to your local machine:
`git clone <repository-url>`
2. Navigate to the project directory:
`cd <project-directory>``
3. Initialize Terraform:
`terraform init`
4. Review and customize the variables in the variables.tf file as needed.
5.  Create a terraform.tfvars file (or use -var options with terraform apply) to provide values for your variables.
6. Apply the Terraform configuration:
`terraform apply`
7. Confirm and apply the changes by typing "yes" when prompted.
8. Once the deployment is complete, Terraform will display the outputs, including VPC and subnet IDs.

### Project Structure
The project structure is organized as follows:

- __main.tf__: Defines the AWS provider, variables, resources, and outputs.
- __variables.tf__: Declares input variables and their descriptions.
- __terraform.tfvars__: Provides values for variables (create this file).
- __outputs.tf__: Defines the output values displayed after deployment.

#### Variables
- __cidr_blocks__: A list of CIDR blocks and name tags for VPC and subnets.
- __environment__: Deployment environment (e.g., "dev", "prod").

#### Resources
- __aws_vpc__: Defines an AWS VPC resource with the specified CIDR block and tags.
- __aws_subnet__: Defines AWS subnets within the VPC.
- __data.aws_vpc.existing_vpc__: Retrieves information about an existing VPC.

####Outputs
- __vpc-id__: Displays the VPC's name tag.
- __subnet-1-id__: Displays the name tag for subnet 1.
- __subnet-2-id__: Displays the name tag for subnet 2.

### Terraform Commands
- __terraform init__: Initialize the Terraform project.
- __terraform plan__: Review the execution plan.
- __terraform apply__: Apply the Terraform configuration to create AWS resources.
- __terraform destroy__: Destroy all created resources.
- __terraform output__: Display the output values.