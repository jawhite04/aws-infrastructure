terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.7"
    }
  }
  backend "s3" {
    key    = "aws-org-manage/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "time" {}

provider "aws" {
  region  = "us-east-1"
  profile = "management-account"
}

provider "aws" {
  # for creating users in the liine takehome account
  alias   = "liine_take_home"
  region  = "us-east-1"
  profile = "management-account"
  assume_role {
    role_arn     = "arn:aws:iam::${aws_organizations_account.liine_take_home.id}:role/OrganizationAccountAccessRole"
    session_name = "TerraformDeployment"
  }
}

provider "aws" {
  # for creating users in the sandbox account
  alias   = "aws_sandbox"
  region  = "us-east-1"
  profile = "management-account"
  assume_role {
    role_arn     = "arn:aws:iam::${aws_organizations_account.aws_sandbox.id}:role/OrganizationAccountAccessRole"
    session_name = "TerraformDeployment"
  }
}

provider "aws" {
  # for creating users in the dns manager account
  alias   = "jawhite04_dns_manager"
  region  = "us-east-1"
  profile = "management-account"
  assume_role {
    role_arn     = "arn:aws:iam::${aws_organizations_account.jawhite04_dns_manager.id}:role/OrganizationAccountAccessRole"
    session_name = "TerraformDeployment"
  }
}
