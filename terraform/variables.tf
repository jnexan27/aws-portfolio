variable "aws_region" {
  description = "Región de AWS donde se desplegará la infraestructura"
  type        = string
  default     = "us-east-1" 
}

variable "bucket_name" {
  description = "Nombre del bucket S3 para el portafolio (debe ser único globalmente)"
  type        = string
  default     = "portafolio-aws-jesus" # Nombre del bucket existente
}

variable "domain_name" {
  description = "Lista de dominios alternativos (CNAMEs) para CloudFront (opcional)"
  type        = list(string)
  default     = []
}

variable "contact_email" {
  description = "Correo electrónico donde recibirás los mensajes del formulario de contacto"
  type        = string
  default     = "jnexan20@gmail.com" # ¡CAMBIAR POR TU CORREO REAL!
}
