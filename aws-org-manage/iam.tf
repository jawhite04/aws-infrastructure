#######################
# JAW DNS Manager
#######################
resource "aws_iam_policy" "route53_contributor_policy" {
  provider = aws.jawhite04_dns_manager
  name     = "Route53ContributorAccess"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action   = "route53:*"
      Effect   = "Allow"
      Resource = "*"
    }]
  })
}

resource "aws_iam_role" "route53_contributor_role" {
  provider = aws.jawhite04_dns_manager
  name     = "route53-contributor"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = ["arn:aws:iam::${aws_organizations_organization.root.master_account_id}:root"]
        },
        Action = "sts:AssumeRole",
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "route53_policy_attach" {
  provider   = aws.jawhite04_dns_manager
  role       = aws_iam_role.route53_contributor_role.name
  policy_arn = aws_iam_policy.route53_contributor_policy.arn
}
