output "database_identifier" {
  description = "RDS instance identifier."
  value       = aws_db_instance.postgresql.identifier
}

output "database_address" {
  description = "Private PostgreSQL DNS address."
  value       = aws_db_instance.postgresql.address
}

output "database_port" {
  description = "PostgreSQL port."
  value       = aws_db_instance.postgresql.port
}

output "database_name" {
  description = "Initial PostgreSQL database name."
  value       = aws_db_instance.postgresql.db_name
}

output "database_jdbc_url" {
  description = "JDBC URL consumed by the application and authentication Lambda."
  value       = "jdbc:postgresql://${aws_db_instance.postgresql.address}:${aws_db_instance.postgresql.port}/${aws_db_instance.postgresql.db_name}"
}

output "database_security_group_id" {
  description = "Security group protecting PostgreSQL."
  value       = aws_security_group.database.id
}
