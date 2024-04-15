#######################
# Organizational Units
#######################
resource "aws_organizations_organizational_unit" "sandboxes" {
  name      = "sandboxes"
  parent_id = aws_organizations_organization.root.roots[0].id
}

resource "aws_organizations_organizational_unit" "suspended" {
  name      = "suspended"
  parent_id = aws_organizations_organization.root.roots[0].id
}

#######################
# OU SCPs
#######################
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
  target_id = aws_organizations_organizational_unit.suspended.id
}
