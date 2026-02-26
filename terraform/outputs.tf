output "s3_bucket_name" {
  description = "Nombre del bucket S3 de origen"
  value       = aws_s3_bucket.portfolio.id
}

output "cloudfront_domain_name" {
  description = "La URL proporcionada por CloudFront para acceder al sitio"
  value       = aws_cloudfront_distribution.portfolio.domain_name
}

output "cloudfront_distribution_id" {
  description = "El ID de la distribución de CloudFront (útil para invalidaciones CACHE)"
  value       = aws_cloudfront_distribution.portfolio.id
}
