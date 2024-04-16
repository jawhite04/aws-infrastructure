variable "aws_acm_certificates" {}
variable "aws_route53_records" {}
variable "aws_route53_zones" {}

# resource "aws_acm_certificate_validation" "cert_validation" {
#   for_each        = aws_acm_certificate.certificate
#   certificate_arn = each.value.arn
#   validation_record_fqdns = [
#     for record in aws_route53_record.cert_validation : record.fqdn if record.zone_id == aws_route53_zone.zones[each.key].zone_id
#   ]
# }

resource "aws_acm_certificate_validation" "cert_validation" {
  for_each        = var.aws_acm_certificates
  certificate_arn = each.value.arn
  validation_record_fqdns = [
    for record in var.aws_route53_records.cert_validation : record.fqdn if record.zone_id == var.aws_route53_zones.zones[each.key].zone_id
  ]
}
