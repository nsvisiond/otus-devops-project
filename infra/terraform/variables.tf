variable cloud_id {
  description = "Cloud"
}
variable folder_id {
  description = "Folder"
}
variable zone {
  description = "Zone"
  # Значение по умолчанию
  default = "ru-central1-a"
}
variable public_key_path {
  # Описание переменной
  description = "Path to the public key used for ssh access"
}
variable private_key_path {
  # Описание переменной
  description = "Path to the private key used for ssh access"
}

variable nat_image_id {
  description = "Disk image"
}
variable gitlab_image_id {
  description = "Disk image"
}

variable image_id {
  description = "Disk image"
}
variable subnet_id {
  description = "Subnet"
}
variable network_id {
  description = "Network"
}

variable service_account_key_file {
  description = "key.json"
}

variable "instance_size_master" {
  type    = number
  default = 3
}
variable "instance_size_node" {
  type    = number
  default = 2
}
variable "instance_size_bastion" {
  type    = number
  default = 1
}
variable gitlab_domain {
  description = "Gitlab Domain"
}
variable app_domain {
  description = "App Domain"
}
variable bastion_domain {
  description = "Bastion Domain"
}