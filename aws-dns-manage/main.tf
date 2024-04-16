locals {
  domains = toset([
    "jawhite04.com",
    "jawhite04.net",
    "jawhite04.org",
    "jawhite04.dev"
  ])
}

resource "aws_acm_certificate" "certificate" {
  for_each          = local.domains
  domain_name       = each.key
  validation_method = "DNS"

  subject_alternative_names = [
    "*.${each.key}",
    "*.api.${each.key}"
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_zone" "zones" {
  for_each = local.domains
  name     = each.key
}

resource "aws_route53_record" "cert_validation" {
  for_each = { for val in flatten([
    for cert in aws_acm_certificate.certificate : [
      for dvo in cert.domain_validation_options : {
        domain_name = dvo.domain_name,
        name        = dvo.resource_record_name,
        type        = dvo.resource_record_type,
        record      = dvo.resource_record_value,
        zone_id     = aws_route53_zone.zones[cert.domain_name].zone_id
      }
    ]
    # create cert validation records for "*.domain.com", "*.api.domain.com"; exclude "domain.com"
    ]) : val.domain_name => val if val.domain_name != trimprefix(val.domain_name, "*.")
  }

  zone_id = each.value.zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
  ttl     = 60
}

variable "dns_validation" {
  type    = bool
  default = false
}

module "dns_validation" {
  count                = var.dns_validation ? 1 : 0
  source               = "./dns_validation"
  aws_acm_certificates = aws_acm_certificate.certificate
  aws_route53_records  = aws_route53_record.cert_validation
  aws_route53_zones    = aws_route53_zone.zones
}

output "nameservers" {
  value = { for domain, zone in aws_route53_zone.zones : domain => zone.name_servers }
}
