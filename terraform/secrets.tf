resource "aws_secretsmanager_secret" "postgres" {
  name        = "${local.name_prefix}/postgres"
  description = "Postgres credentials"

  tags = local.tags

}

resource "aws_secretsmanager_secret_version" "postgres" {
  secret_id = aws_secretsmanager_secret.postgres.id

  secret_string = jsonencode({
    username = var.db_username
    password = var.db_password
    host     = aws_db_instance.postgres.address
    port     = "5432"
    dbname   = var.db_name
  })
}