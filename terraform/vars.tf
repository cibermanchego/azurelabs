variable "region" {
  default = "West US 2"
}

variable "ip_whitelist" {
  description = "A list of CIDRs that will be allowed to access the instances"
  type        = list(string)
  default     = [""]
}
variable "num_ws" {
  description = "Number of workstations to create"
  type = number
  default = 1
}

variable "servers_subnet_cidr" {
    description = "CIDR to use for the Servers subnet"
    default = "192.168.10.0/24"
}

variable "workstations_subnet_cidr" {
    description = "CIDR to use for the Workstations subnet"
    default = "192.168.20.0/24"
}

variable "logger_admin_user" {
    description = "Name of the initial admin user on the logger box"
    # default username
    default = "loggeradmin"
}

variable "public_key_name" {
  description = "A name for SSH Keypair to use to auth to logger. Can be anything you specify."
  default     = "id_logger"
}

variable "public_key_path" {
  description = "Path to the public key to be loaded into the logger authorized_keys file"
  type        = string
  default     = "/home/user/.ssh/id_logger.pub"
}

# Note: must use ssh key without passphrase. not supported by Terraform.
variable "private_key_path" {
  description = "Path to the private key to use to authenticate to logger."
  type        = string
  default     = "/home/user/.ssh/id_logger"
}
#Default local administrator username and password for all Windows VMs
variable "windows_local_admin" {
  description = "Local admin username for Windows VMs."
  type        = string
  default     = "andres"
}
variable "windows_local_admin_password" {
  description = "Local admin password for Windows VMs."
  type        = string
  default     = "Iniestademivida123!"
}