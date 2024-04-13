provider "aws" {
  region = "us-east-1"
}

locals {
  organizational_units = [
    "sandboxes",
    "suspended"
  ]
  suspended_index = index(local.organizational_units, "suspended")
}

# enable AWS Organizations
resource "aws_organizations_organization" "root" {
  feature_set = "ALL"
  enabled_policy_types = [
    "AISERVICES_OPT_OUT_POLICY",
    "SERVICE_CONTROL_POLICY"
  ]

  aws_service_access_principals = [
    "sso.amazonaws.com" # IAM Identity Center 
  ]
}

# create organizational units
resource "aws_organizations_organizational_unit" "ou" {
  count     = length(local.organizational_units)
  name      = local.organizational_units[count.index]
  parent_id = aws_organizations_organization.root.roots[0].id
}

resource "aws_organizations_policy" "suspended_deny_all" {
  name        = "DenyAll"
  description = "Denies access to all services"
  type        = "SERVICE_CONTROL_POLICY"

  content = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Deny",
    "Action": "*",
    "Resource": "*"
  }]
}
POLICY
}

resource "aws_organizations_policy_attachment" "deny_all_suspended" {
  policy_id = aws_organizations_policy.suspended_deny_all.id
  target_id = aws_organizations_organizational_unit.ou[local.suspended_index].id
}
