variable "aws_region" {
  description = "AWS region to deploy to"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.small"
}

variable "project_name" {
  description = "Project name for tagging resources"
  type        = string
  default     = "browser-terminal"
}

variable "domain_name" {
  description = "Domain name for the application (optional, leave empty to skip Route53)"
  type        = string
  default     = ""
}

variable "ssh_public_key_path" {
  description = "Path to your SSH public key"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed to SSH (use your IP for security, or 0.0.0.0/0 for anywhere)"
  type        = string
  default     = "0.0.0.0/0"
}
