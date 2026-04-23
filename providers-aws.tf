terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region   
  profile = "kernelops"  
}

provider "aws" {
  alias   = "virginia"       
  region  = "us-east-1"      
  profile = "kernelops"  
}