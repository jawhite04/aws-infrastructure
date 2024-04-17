###########################
# enable AWS Organizations
###########################
resource "aws_organizations_organization" "root" {
  feature_set = "ALL"
  enabled_policy_types = [
    "AISERVICES_OPT_OUT_POLICY",
    "SERVICE_CONTROL_POLICY"
  ]

  aws_service_access_principals = [
    "sso.amazonaws.com",    # IAM Identity Center
    "account.amazonaws.com" # Account Management
  ]
}

# manage organizations in `organizations.tf`
# manage accounts in `accounts.tf`
# manage users in `iam.tf`
