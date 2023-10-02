terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.17.0"
    }
    vsphere = {
      source = "hashicorp/vsphere"
      version = "2.4.3"
    }
  }
}