variable "aws_region" {
  description = "AWS region used by the database."
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Infrastructure deployment environment."
  type        = string

  validation {
    condition     = contains(["homolog", "prod"], var.environment)
    error_message = "The environment must be homolog or prod."
  }
}

variable "database_name" {
  description = "Initial PostgreSQL database name."
  type        = string
  default     = "mecanica"

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9_]+$", var.database_name))
    error_message = "The database name must start with a letter and contain only letters, numbers, or underscores."
  }
}

variable "database_username" {
  description = "PostgreSQL administrator username."
  type        = string
  default     = "mecanica_admin"

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9_]+$", var.database_username))
    error_message = "The database username must start with a letter and contain only letters, numbers, or underscores."
  }
}

variable "database_password" {
  description = "PostgreSQL administrator password."
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.database_password) >= 12
    error_message = "The database password must contain at least 12 characters."
  }
}

variable "postgres_engine_version" {
  description = "PostgreSQL engine version available in the Learner Lab."
  type        = string
  default     = "16.14"
}

variable "database_instance_class" {
  description = "RDS instance class."
  type        = string
  default     = "db.t4g.micro"
}

variable "allocated_storage_gib" {
  description = "Allocated PostgreSQL storage in GiB."
  type        = number
  default     = 20

  validation {
    condition     = var.allocated_storage_gib >= 20
    error_message = "PostgreSQL storage must be at least 20 GiB."
  }
}
