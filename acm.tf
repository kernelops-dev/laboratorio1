
resource "aws_acm_certificate" "website" {
  provider = aws.virginia

  domain_name       = var.site_domain
  validation_method = "DNS"

  tags = {
    Name        = var.site_domain
    Environment = var.environment
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "website" {
  provider = aws.virginia
  certificate_arn = aws_acm_certificate.website.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}