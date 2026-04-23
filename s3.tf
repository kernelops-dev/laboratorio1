
resource "aws_s3_bucket" "website" {
  bucket = var.site_domain
  force_destroy = true
  tags = {
    Name        = var.site_domain
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}


resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}


resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.id
  block_public_acls       = true   
  block_public_policy     = true   
  ignore_public_acls      = true   
  restrict_public_buckets = true  
}

resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.website.id
  key          = "index.html"                     
  source       = "${path.module}/site/index.html" 
  content_type = "text/html"                      
  etag         = filemd5("${path.module}/site/index.html") 
}

resource "aws_s3_object" "error" {
  bucket       = aws_s3_bucket.website.id
  key          = "error.html"
  source       = "${path.module}/site/error.html"
  content_type = "text/html"
  etag         = filemd5("${path.module}/site/error.html")
}


data "aws_iam_policy_document" "s3_cloudfront_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.website.arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.website.arn] 
    }
  }
}


resource "aws_s3_bucket_policy" "website" {
  bucket = aws_s3_bucket.website.id
  policy = data.aws_iam_policy_document.s3_cloudfront_policy.json # Convierte el documento a JSON
}