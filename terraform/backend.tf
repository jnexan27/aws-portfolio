# ------------------------------------------------------------------------------
# BACKEND SERVERLESS: API GATEWAY + LAMBDA + SNS
# ------------------------------------------------------------------------------

# 1. Comprimir el código JS antes de subirlo a AWS
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/../src/contact.js"
  output_path = "${path.module}/contact.zip"
}

# 2. SNS Topic y Suscripción (El cartero)
resource "aws_sns_topic" "contact_topic" {
  name = "portafolio-contact-topic"
}

resource "aws_sns_topic_subscription" "contact_email_sub" {
  topic_arn = aws_sns_topic.contact_topic.arn
  protocol  = "email"
  endpoint  = var.contact_email # Variable definida en variables.tf
}

# 3. Permisos (IAM Role) para la función Lambda
resource "aws_iam_role" "lambda_role" {
  name = "portafolio_lambda_contact_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# Permiso básico para poder imprimir logs en CloudWatch
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Permiso específico para publicar en el Topic SNS creado
resource "aws_iam_policy" "lambda_sns_policy" {
  name        = "portafolio_lambda_sns_policy"
  description = "Permite a Lambda publicar en el topic de contacto de SNS"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action   = "sns:Publish"
      Effect   = "Allow"
      Resource = aws_sns_topic.contact_topic.arn
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_sns_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_sns_policy.arn
}

# 4. Función Lambda (El cerebro computacional)
resource "aws_lambda_function" "contact_lambda" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "PortafolioContactFunction"
  role             = aws_iam_role.lambda_role.arn
  handler          = "contact.handler"
  runtime          = "nodejs18.x" # Entorno de Node.js actual
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = {
      SNS_TOPIC_ARN = aws_sns_topic.contact_topic.arn
    }
  }
}

# 5. API Gateway (La puerta de entrada web)
resource "aws_apigatewayv2_api" "contact_api" {
  name          = "portafolio-contact-api"
  protocol_type = "HTTP"
  
  cors_configuration {
    allow_origins = ["*"] # Permite llamadas desde cualquier dominio (CORS)
    allow_methods = ["POST", "OPTIONS"]
    allow_headers = ["content-type"]
    max_age       = 300
  }
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.contact_api.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id                 = aws_apigatewayv2_api.contact_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.contact_lambda.invoke_arn
  integration_method     = "POST"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "post_contact" {
  api_id    = aws_apigatewayv2_api.contact_api.id
  route_key = "POST /contact"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

# Permiso final: Dejar que la API invoque a la Lambda
resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.contact_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.contact_api.execution_arn}/*/*"
}
