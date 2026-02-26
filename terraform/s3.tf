# S3 Bucket para alojar los archivos estáticos
resource "aws_s3_bucket" "portfolio" {
  bucket = var.bucket_name
}

# Bloquear todo el acceso público directo al bucket S3
resource "aws_s3_bucket_public_access_block" "portfolio" {
  bucket = aws_s3_bucket.portfolio.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Configuración del bucket para alojamiento web estático (Opcional, pero recomendado)
resource "aws_s3_bucket_website_configuration" "portfolio" {
  bucket = aws_s3_bucket.portfolio.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "404.html" # Cambia esto si tienes otra página de error
  }
}

# Política del bucket para permitir lectura solo desde CloudFront vía OAC
resource "aws_s3_bucket_policy" "portfolio_oac" {
  bucket = aws_s3_bucket.portfolio.id
  policy = data.aws_iam_policy_document.allow_cloudfront_oac.json
}

data "aws_iam_policy_document" "allow_cloudfront_oac" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.portfolio.arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.portfolio.arn]
    }
  }
}
