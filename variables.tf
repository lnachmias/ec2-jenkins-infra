variable "region" {
  default = "us-east-1"
}
variable "vpc_cidr" {
  description = "VPC CIDR block"
}
variable "public_subnet_1_cidr" {
  description = "Public Subnet 1 CIDR block"
}
variable "linux_root_volume_size" {
  type        = number
  description = "Volumen size of root volumen of Linux Server"
}
variable "linux_root_volume_type" {
  type        = string
  description = "Volumen type of root volumen of Linux Server."
  default     = "gp2"
}