resource "time_sleep" "wait_for_account_creation" {
  create_duration = "2m"

  depends_on = [
    aws_organizations_account.jawhite04_dns_manager,
    aws_organizations_account.com_jawhite04,
    aws_organizations_account.aws_sandbox,
  ]
}

#######################
# Accounts
#######################
#######################
# JAW Sandbox
#######################
resource "aws_organizations_account" "aws_sandbox" {
  name              = "jaw-aws-sandbox"
  email             = var.aws_sandbox_email
  parent_id         = aws_organizations_organizational_unit.sandboxes.id
  role_name         = "OrganizationAccountAccessRole"
  close_on_deletion = true
}

module "aws_sandbox_bucket" {
  source = "../aws-s3-statefiles/modules/s3-bucket"
  providers = {
    aws.target = aws.aws_sandbox
  }
  aws_account = aws_organizations_account.aws_sandbox.id

  depends_on = [
    time_sleep.wait_for_account_creation
  ]
}

#######################
# JAW DNS Manager
#######################
resource "aws_organizations_account" "jawhite04_dns_manager" {
  name              = "jaw-jawhite04-dns-manager"
  email             = var.jawhite04_dns_manager_email
  parent_id         = aws_organizations_organizational_unit.jawhite04_domains.id
  role_name         = "OrganizationAccountAccessRole"
  close_on_deletion = true
}

module "jawhite04_dns_manager_bucket" {
  source = "../aws-s3-statefiles/modules/s3-bucket"
  providers = {
    aws.target = aws.jawhite04_dns_manager
  }
  aws_account = aws_organizations_account.jawhite04_dns_manager.id

  depends_on = [
    time_sleep.wait_for_account_creation
  ]
}

#######################
# jawhite04.com
#######################
resource "aws_organizations_account" "com_jawhite04" {
  name              = "com-jawhite04"
  email             = var.com_jawhite04_email
  parent_id         = aws_organizations_organizational_unit.jawhite04_domains.id
  role_name         = "OrganizationAccountAccessRole"
  close_on_deletion = true
}

module "com_jawhite04_bucket" {
  source = "../aws-s3-statefiles/modules/s3-bucket"
  providers = {
    aws.target = aws.com_jawhite04
  }
  aws_account = aws_organizations_account.com_jawhite04.id

  depends_on = [
    time_sleep.wait_for_account_creation
  ]
}

module "com_jawhite04_vpc" {
  source = "./modules/default-vpc"
  providers = {
    aws.target = aws.com_jawhite04
  }

  depends_on = [
    time_sleep.wait_for_account_creation
  ]
}
