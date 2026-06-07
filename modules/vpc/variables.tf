variable "env_name" {
  type        = string
  description = "The name of the environment (dev, staging, prod)"
}

variable "vpc_cidr" {
  type        = string
  description = "The base IP range for the VPC"
}

variable "public_subnet_cidr" {
  type        = string
  description = "The IP range for the public subnet"
}