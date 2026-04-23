
resource "aws_cloudfront_origin_access_control" "website" {
  name                              = "${var.site_domain}-oac"
  description                       = "OAC para permitir acceso seguro de CloudFront al bucket S3"
  origin_access_control_origin_type = "s3"         
  signing_behavior                  = "always"    
  signing_protocol                  = "sigv4"      
}

resource "aws_cloudfront_distribution" "website" {
  enabled = true
  aliases = [var.site_domain]

  origin {
    domain_name = aws_s3_bucket.website.bucket_regional_domain_name
    origin_id   = "S3-${var.site_domain}"

    origin_access_control_id = aws_cloudfront_origin_access_control.website.id
  }

  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${var.site_domain}"

    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.website.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  price_class = "PriceClass_100"

  tags = {
    Name        = var.site_domain
    Environment = var.environment
  }
}