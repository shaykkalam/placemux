variable "env_name" {
  type        = string
  description = "The name of the environment (dev, staging, prod)"
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC where the DB should be deployed"
}

variable "subnet_ids" {
  type        = list(string)
  description = "The list of subnet IDs where the DB subnet group will span"
}