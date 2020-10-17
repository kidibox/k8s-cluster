variable "resource_group_name" {
  default = "kidibox"
}

variable "cluster_name" {
  default = "kidibox"
}

variable "dns_prefix" {
  default = "kidibox"
}

variable "location" {
  default = "West Europe"
}

variable "node_count" {
  default = 2
}

variable "node_size" {
  default = "Standard_B2s"
}

variable "key_vault_owner_object_ids" {
  type    = list
  default = []
}

variable "cluster_admin_object_ids" {
  type    = list
  default = []
}
