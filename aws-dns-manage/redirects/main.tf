#########################################################
# configure HTTP 301 via S3 & Cloudfront for .net/.org
#########################################################

locals {
  redirect_target = "jawhite04.com"
}

data "aws_caller_identity" "current" {}

##########################
# jawhite04.org
##########################
data "aws_acm_certificate" "org_cert" {
  domain   = "jawhite04.org"
  statuses = ["ISSUED"]
}

data "aws_route53_zone" "org_zone" {
  name = "jawhite04.org"
}

resource "aws_s3_bucket" "org_redirect_bucket" {
  bucket = "http-redirect-jawhite04-org-${data.aws_caller_identity.current.account_id}"
}

resource "aws_s3_bucket_website_configuration" "org_redirect_bucket" {
  bucket = aws_s3_bucket.org_redirect_bucket.bucket
  redirect_all_requests_to {
    host_name = local.redirect_target
    protocol  = "https"
  }
}

resource "aws_cloudfront_distribution" "org_redirect" {
  origin {
    domain_name = aws_s3_bucket.org_redirect_bucket.bucket_regional_domain_name
    origin_id   = "S3-${aws_s3_bucket.org_redirect_bucket.id}"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Permanent redirect for jawhite04.org -> jawhite04.com"
  default_root_object = ""

  aliases = ["jawhite04.org"]

  default_cache_behavior {
    target_origin_id       = "S3-${aws_s3_bucket.org_redirect_bucket.id}"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }

  viewer_certificate {
    acm_certificate_arn      = data.aws_acm_certificate.org_cert.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2019"
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB"]
    }
  }

  price_class = "PriceClass_All"
}

resource "aws_route53_record" "org_redirect_bucket_dns" {
  zone_id = data.aws_route53_zone.org_zone.zone_id
  name    = "jawhite04.org"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.org_redirect.domain_name
    zone_id                = aws_cloudfront_distribution.org_redirect.hosted_zone_id
    evaluate_target_health = false
  }
}

##########################
# jawhite04.net
##########################
data "aws_acm_certificate" "net_cert" {
  domain   = "jawhite04.net"
  statuses = ["ISSUED"]
}

data "aws_route53_zone" "net_zone" {
  name = "jawhite04.net"
}

resource "aws_s3_bucket" "net_redirect_bucket" {
  bucket = "http-redirect-jawhite04-net-${data.aws_caller_identity.current.account_id}"
}

resource "aws_s3_bucket_website_configuration" "net_redirect_bucket" {
  bucket = aws_s3_bucket.net_redirect_bucket.bucket
  redirect_all_requests_to {
    host_name = local.redirect_target
    protocol  = "https"
  }
}

resource "aws_cloudfront_distribution" "net_redirect" {
  origin {
    domain_name = aws_s3_bucket.net_redirect_bucket.bucket_regional_domain_name
    origin_id   = "S3-${aws_s3_bucket.net_redirect_bucket.id}"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Permanent redirect for jawhite04.net -> jawhite04.com"
  default_root_object = ""

  aliases = ["jawhite04.net"]

  default_cache_behavior {
    target_origin_id       = "S3-${aws_s3_bucket.net_redirect_bucket.id}"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }

  viewer_certificate {
    acm_certificate_arn      = data.aws_acm_certificate.net_cert.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2019"
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB"]
    }
  }

  price_class = "PriceClass_All"
}

resource "aws_route53_record" "net_redirect_bucket_dns" {
  zone_id = data.aws_route53_zone.net_zone.zone_id
  name    = "jawhite04.net"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.net_redirect.domain_name
    zone_id                = aws_cloudfront_distribution.net_redirect.hosted_zone_id
    evaluate_target_health = false
  }
}
