provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "mecanica"
      Component   = "database"
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  }
}
