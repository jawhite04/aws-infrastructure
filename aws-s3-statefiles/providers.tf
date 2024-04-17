terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    key    = "aws-s3-statefiles/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  alias  = "source"
  region = "us-east-1"
}
