
resource "random_string" "default" {
  length = 4
}

variable "nameBase" {
  default = ""
}


variable "azRegion" {
    default = "centralus"
    description = "location where the resource is hosted"
}

variable "rgName" {
    default = "Sprinter"
    description = "name of the resource group"
}

variable "AvailabilitySetName" {
    default = "ASSprinter"
    description = "name of availability set"
}

variable "machineName" {
  default = "vmjkwWS"
  description = "name of the vm"
}

variable "username" {
  default = "sysAdmin"
  description = "admin user name"
}

variable "workstation_ip" {
  type = string
  description = "Ip address for the local workstation that will access the vm once it has been created"
}

variable "vnetName" {
  default = "vnet"
}

variable "subnetName" {
  default = "inet"
}

variable "vmPublicIpName" {
  default = "vm_public_ip"  
}

variable "domainLabel" {
  default = "vm-jkw-ws-sprinter"
}

variable "nicSprinterName" {
  default = "nicSprinter"
}
variable "nsgSprinterName" {
  default = "sprinter-network-security-group"
}
