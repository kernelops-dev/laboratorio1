output "cloudfront_domain_name" {
  description = "Dominio de la distribución CloudFront"
  value       = aws_cloudfront_distribution.website.domain_name
}

output "website_url" {
  description = "URL completa para acceder al sitio (HTTPS)"
  value       = "https://${var.site_domain}"
}

output "s3_bucket_id" {
  description = "ID del bucket S3 creado"
  value       = aws_s3_bucket.website.id
}