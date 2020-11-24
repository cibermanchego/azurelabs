variable "region" {
  default = "West US 2"
}

variable "ip_whitelist" {
  description = "A list of CIDRs that will be allowed to access the instances"
  type        = list(string)
  default     = [""]
}