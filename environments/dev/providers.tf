provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = var.environment
      Owner       = var.owner
      Application = var.application
      CostCenter  = var.cost_center
      ManagedBy   = "terraform"
      Project     = var.project_name
    }
  }
}
