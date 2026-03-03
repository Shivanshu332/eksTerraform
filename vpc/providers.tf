provider "aws"{
    region = "ap-south-1"
}

terraform {
  backend "s3" {
    bucket = "eks-terraform-s3-backend-shiv"
    key = "dev/terraform.tfstate"
    region = "ap-south-1"
    use_lockfile = true
  }
  required_providers {
    aws ={
        source = "hashicorp/aws"
        version = "~> 6.0"
    }
  }
}