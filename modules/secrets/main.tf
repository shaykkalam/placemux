# 1. Create the secret container container
resource "aws_secretsmanager_secret" "app_secrets" {
  name        = "${var.env_name}-application-secrets"
  description = "Secure credentials storage vault for the ${var.env_name} environment"

  # Force deletion without recovery window for quick learning/testing iteration
  recovery_window_in_days = 0

  tags = {
    Environment = var.env_name
  }
}

# 2. Add placeholder credentials structure inside the vault
resource "aws_secretsmanager_secret_version" "initial_version" {
  secret_id = aws_secretsmanager_secret.app_secrets.id
  secret_string = jsonencode({
    DATABASE_URL = "placeholder_db_connection_string"
    API_KEY      = "placeholder_secure_api_key"
    JWT_SECRET   = "placeholder_jwt_token_signing_key"
  })
}