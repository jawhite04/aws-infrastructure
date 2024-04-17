#######################
# JAW DNS Manager
#######################
resource "aws_iam_user" "jawhite04_dns_manager_route53_user" {
  provider = aws.jawhite04_dns_manager
  name     = "route53-user"
}

resource "aws_iam_policy" "route53_user_policy" {
  provider = aws.jawhite04_dns_manager
  name     = "Route53FullAccess"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action   = "route53:*"
      Effect   = "Allow"
      Resource = "*"
    }]
  })
}

resource "aws_iam_user_policy_attachment" "route53_user_policy" {
  provider   = aws.jawhite04_dns_manager
  user       = aws_iam_user.jawhite04_dns_manager_route53_user.name
  policy_arn = aws_iam_policy.route53_user_policy.arn
}
