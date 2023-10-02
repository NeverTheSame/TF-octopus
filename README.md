# TF-octopus
This Terraform project deploys an Amazon Web Services (AWS) Virtual Private Cloud (VPC) with subnets in the us-west-1 region and VM resources in on-premises VMware vCenter 7.0. It's designed for streamlining entities' creation process in different environments. 

## Table of Contents
- Prerequisites
- Getting Started with AWS networking
  - Project Structure
  - Variables
  - Resources
  - Outputs
- Getting Started with AWS EC2 instances
- Getting Started with VMware vCenter
- Terraform Commands

### Prerequisites
Before you begin, ensure you have the following prerequisites:

- Terraform installed on your local machine.
- AWS credentials configured with the necessary permissions. These credentials should be set up in your ~/.aws/credentials file.
### Getting Started with AWS
1. Clone this repository to your local machine:
`git clone <repository-url>`
2. Navigate to the project directory:
`cd <project-directory>`
3. Initialize Terraform:
`terraform init`
4. Review and customize the variables in the variables.tf file as needed.
5.  Create a terraform.tfvars file (or use -var options with terraform apply) to provide values for your variables.
6. Apply the Terraform configuration:
`terraform apply`
7. Confirm and apply the changes by typing "yes" when prompted.
8. Once the deployment is complete, Terraform will display the outputs, including VPC and subnet IDs.

#### Project Structure
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

#### Outputs
- __vpc-id__: Displays the VPC's name tag.
- __subnet-1-id__: Displays the name tag for subnet 1.
- __subnet-2-id__: Displays the name tag for subnet 2.


### Getting Started with AWS EC2 instances
- To start working with this project navigate to the project directory: `cd web`


### Getting Started with VMware vCenter
This Terraform configuration defines the provisioning of a virtual machine (VM) on a VMware vSphere infrastructure. It includes the setup of the necessary providers, data sources for datacenter, datastore, compute cluster, and network, as well as the creation of a virtual machine.
- To start working with this project navigate to the project directory: `cd vmware`

#### Configuration Variables
- __username__: The username for authenticating with the vCenter server.
- __password__: The password for authenticating with the vCenter server.
- __vsphere_server__: The address of the vCenter server.

#### Provider Configuration
The vsphere provider is configured to connect to the VMware vSphere infrastructure using the provided credentials and server address. Additionally, the `allow_unverified_ssl` option is set to true to allow connections to vCenter servers with self-signed SSL certificates.

#### Data Sources 
- __vsphere_datacenter__: Retrieves information about the datacenter named "1iq-dc" in the vSphere infrastructure.
- __vsphere_datastore__: Retrieves information about the datastore named "vsanDatastore" associated with the specified datacenter.
- __vsphere_compute_cluster__: Retrieves information about the compute cluster named "1iq-vsan" within the specified datacenter.
- __vsphere_network__: Retrieves information about the network named "vLAN Lab" within the specified datacenter.

#### Virtual Machine Resource
The vsphere_virtual_machine resource defines the creation of a virtual machine with the following characteristics:
```
Name: "opensuse-15-6"
Resource pool: The resource pool associated with the specified compute cluster.
Datastore: The datastore associated with the specified datacenter.
CPU: 1 virtual CPU.
Memory: 2048 MB.
Guest ID: "other3xLinux64Guest."
Network: Connected to the "vLAN Lab" network.
Disk: One disk labeled "disk0" with a size of 16 GB.
No wait for guest network timeout.
```
#### Output
The vm_ip output provides the IP address of the VMware vSphere virtual machine. This IP address can be used to access and manage the provisioned virtual machine.


### Terraform Commands
- __terraform init__: Initialize the Terraform project.
- __terraform plan__: Review the execution plan.
- __terraform apply__: Apply the Terraform configuration to create AWS resources.
- __terraform destroy__: Destroy all created resources.
- __terraform output__: Display the output values.