terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    key     = "aws-dns-manage/redirects/terraform.tfstate"
    region  = "us-east-1"
    profile = "dns-manager"
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "dns-manager"
}
