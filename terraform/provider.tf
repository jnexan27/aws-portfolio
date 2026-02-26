terraform {
  required_version = ">= 1.5.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configuración del proveedor de AWS
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "AWS Portfolio"
      ManagedBy   = "Terraform"
      Environment = "Production"
    }
  }
}
