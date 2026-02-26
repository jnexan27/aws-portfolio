# ------------------------------------------------------------------------------
# RECURSOS PARA EL BACKEND REMOTO DE TERRAFORM (ESTADO Y BLOQUEO)
# ------------------------------------------------------------------------------

# 1. Bucket S3 para guardar el archivo tfstate
resource "aws_s3_bucket" "terraform_state" {
  bucket = "portafolio-aws-jesus-tfstate" # Nombre único para guardar tu estado

  # Evitar borrado accidental (opcional pero recomendado para el estado)
  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name        = "Terraform State Bucket"
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}

# 1.1 Habilitar el versionamiento en el bucket de estado
# Si algo se rompe, podemos volver a una versión anterior del state.
resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# 1.2 Bloquear todo acceso público al bucket de estado (Seguridad Crítica)
resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket                  = aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 2. Tabla DynamoDB para el State Locking (Bloqueo de Estado)
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "portafolio-aws-jesus-tflocks"
  billing_mode = "PAY_PER_REQUEST" # Solo pagas si la usas (0$ estando quieta)
  hash_key     = "LockID"          # Terraform exige que la clave se llame exactamente así

  attribute {
    name = "LockID"
    type = "S" # String
  }

  tags = {
    Name        = "Terraform State Lock Table"
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}
