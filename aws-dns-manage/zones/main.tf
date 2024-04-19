####################################################
# Create Route 53 zones
####################################################

##########################
# jawhite04.com
##########################
resource "aws_route53_zone" "com_zone" {
  name = "jawhite04.com"
}

output "com_zone_details" {
  value = "${aws_route53_zone.com_zone.name} = ${join(", ", aws_route53_zone.com_zone.name_servers)}"
}

##########################
# jawhite04.dev
##########################
resource "aws_route53_zone" "dev_zone" {
  name = "jawhite04.dev"
}

output "dev_zone_details" {
  value = "${aws_route53_zone.dev_zone.name} = ${join(", ", aws_route53_zone.dev_zone.name_servers)}"
}

##########################
# jawhite04.org
##########################
resource "aws_route53_zone" "org_zone" {
  name = "jawhite04.org"
}

output "org_zone_details" {
  value = "${aws_route53_zone.org_zone.name} = ${join(", ", aws_route53_zone.org_zone.name_servers)}"
}

##########################
# jawhite04.net
##########################
resource "aws_route53_zone" "net_zone" {
  name = "jawhite04.net"
}

output "net_zone_details" {
  value = "${aws_route53_zone.net_zone.name} = ${join(", ", aws_route53_zone.net_zone.name_servers)}"
}
