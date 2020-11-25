variable "region" {
  default = "West US 2"
}

variable "ip_whitelist" {
  description = "A list of CIDRs that will be allowed to access the instances"
  type        = list(string)
  default     = [""]
}

variable "servers_subnet_cidr" {
    description = "CIDR to use for the Servers subnet"
    default = "192.168.10.0/24"
}

variable "workstations_subnet_cidr" {
    description = "CIDR to use for the Workstations subnet"
    default = "192.168.20.0/24"
}