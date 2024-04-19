#########################################################
# 1. create ACM Certificate for domains
# 2. create route 53 records for acm certificate validation
# 3. configure aws_acm_certificate_validation
#########################################################

# validation steps from:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation

##########################
# jawhite04.com
##########################
data "aws_route53_zone" "com_zone" {
  name = "jawhite04.com"
}

resource "aws_acm_certificate" "com_cert" {
  domain_name       = "jawhite04.com"
  validation_method = "DNS"

  subject_alternative_names = [
    "*.jawhite04.com",
    "*.api.jawhite04.com"
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "com_dns_validation" {
  for_each = {
    for dvo in aws_acm_certificate.com_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.com_zone.zone_id
}

resource "aws_acm_certificate_validation" "com_dns_validation" {
  certificate_arn         = aws_acm_certificate.com_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.com_dns_validation : record.fqdn]
}

##########################
# jawhite04.dev
##########################
data "aws_route53_zone" "dev_zone" {
  name = "jawhite04.dev"
}

resource "aws_acm_certificate" "dev_cert" {
  domain_name       = "jawhite04.dev"
  validation_method = "DNS"

  subject_alternative_names = [
    "*.jawhite04.dev",
    "*.api.jawhite04.dev"
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "dev_dns_validation" {
  for_each = {
    for dvo in aws_acm_certificate.dev_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.dev_zone.zone_id
}

resource "aws_acm_certificate_validation" "dev_dns_validation" {
  certificate_arn         = aws_acm_certificate.dev_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.dev_dns_validation : record.fqdn]
}

##########################
# jawhite04.org
##########################
data "aws_route53_zone" "org_zone" {
  name = "jawhite04.org"
}

resource "aws_acm_certificate" "org_cert" {
  domain_name       = "jawhite04.org"
  validation_method = "DNS"

  subject_alternative_names = [
    "*.jawhite04.org",
    "*.api.jawhite04.org"
  ]

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_route53_record" "org_dns_validation" {
  for_each = {
    for dvo in aws_acm_certificate.org_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.org_zone.zone_id
}

resource "aws_acm_certificate_validation" "org_dns_validation" {
  certificate_arn         = aws_acm_certificate.org_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.org_dns_validation : record.fqdn]
}

##########################
# jawhite04.net
##########################
data "aws_route53_zone" "net_zone" {
  name = "jawhite04.net"
}

resource "aws_acm_certificate" "net_cert" {
  domain_name       = "jawhite04.net"
  validation_method = "DNS"

  subject_alternative_names = [
    "*.jawhite04.net",
    "*.api.jawhite04.net"
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "net_dns_validation" {
  for_each = {
    for dvo in aws_acm_certificate.net_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.net_zone.zone_id
}

resource "aws_acm_certificate_validation" "net_dns_validation" {
  certificate_arn         = aws_acm_certificate.net_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.net_dns_validation : record.fqdn]
}
