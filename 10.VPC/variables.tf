variable "environment" {
  default = ""
}
variable "project_name" {
  default = ""
}

variable "common_tags" {
  default = {}
}
variable "availability_zones" {
  default = []
}

variable "vpc_cidr_block" {
  default = ""
}

variable "public_subnet_cidr_blocks" {
  default = []
}

variable "private_subnet_cidr_blocks" {
  default = []
}

variable "db_subnet_cidr_blocks" {
  default = []
}