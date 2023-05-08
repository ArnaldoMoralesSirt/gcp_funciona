# GCP resourcers prefix description
variable "prefix" {
  type    = string
  default = "net0"
}
# GCP region
variable "region" {
  type    = string
  default = "europe-west4" #Default Region
}

variable "vpc-sec_cidr" {
  type    = string
  default = "172.30.0.0/22"
}

variable "backend-probe_port" {
  type    = string
  default = "8008"
}

variable "admin_cidr" {
  type    = string
  default = "0.0.0.0/0"
}
