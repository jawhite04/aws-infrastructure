#######################
# JAW DNS Manager
#######################
resource "aws_iam_policy" "route53_contributor_policy" {
  provider = aws.jawhite04_dns_manager
  name     = "Route53ContributorAccess"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Deny"
        Action = [
          "route53:CreateHostedZone",
          "route53:DeleteHostedZone",
          "route53:UpdateHostedZoneComment"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "route53:ChangeResourceRecordSets",
          "route53:ListResourceRecordSets",
          "route53:ListTagsForResource",
          "route53:GetHostedZone"
        ]
        Resource = "arn:aws:route53:::hostedzone/*"
      },
      {
        Effect = "Allow"
        Action = [
          "route53:GetChange"
        ]
        Resource = "arn:aws:route53:::change/*"
      },
      {
        Effect = "Allow"
        Action = [
          "route53:ListHostedZones"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "acm:ListCertificates",
          "acm:DescribeCertificate",
          "acm:GetCertificate",
          "acm:ListTagsForCertificate"
        ]
        Resource = "*"
      }
    ]
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
