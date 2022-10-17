variable "image_version" {
  type    = string
  default = ""
}

variable "open_file_limit" {
  type    = string
  default = ""
}

/* VSphere */
variable "vsphere_host" {
  type    = string
  default = ""
}

variable "vsphere_vcenter_server" {
  type    = string
  default = ""
}

variable "vsphere_username" {
  type    = string
  default = ""
}

variable "vsphere_password" {
  type    = string
  default = ""
}

variable "vsphere_datacenter" {
  type    = string
  default = ""
}

variable "vsphere_resource_pool" {
  type    = string
  default = ""
}

variable "vsphere_cluster" {
  type    = string
  default = ""
}

variable "vsphere_folder" {
  type    = string
  default = ""
}

variable "vsphere_datastore" {
  type    = string
  default = ""
}

/* Virtual Machine */
variable "vm_name" {
  description = "Name of the new VM to create"
  type        = string
  default     = "RancherProdClsTemplate"
}

variable "num_cpus" {
  description = "Number of CPU cores for the machine"
  type        = number
  default     = 2
}

variable "vm_memory" {
  description = "Amount of RAM in MB"
  type        = number
  default     = 4096
}

variable "vm_disk_size" {
  description = "The size of the disk in MB"
  type        = number
  default     = 327680
}

variable "vm_network" {
  description = "Set the network in which the VM will be connected to"
  type        = string
  default     = ""
}

variable "vm_network_card" {
  description = "Set VM network card type"
  type        = string
  default     = ""
}

variable "iso_url" {
  description = "A URL to the ISO containing the installation image or virtual hard drive"
  type        = string
  default     = "https://releases.ubuntu.com/20.04/ubuntu-20.04.4-live-server-amd64.iso"
}

variable "iso_checksum" {
  description = "The checksum for the ISO file or virtual hard drive file"
  type        = string
  default     = "28ccdb56450e643bad03bb7bcf7507ce3d8d90e8bf09e38f6bd9ac298a98eaad"
}

/* SSH */
variable "ssh_host" {
  description = "The address to SSH to"
  type        = string
  default     = ""
}

variable "ssh_username" {
  description = "The username to connect to SSH with"
  type        = string
  default     = ""
}

variable "ssh_password" {
  description = "A plaintext password to use to authenticate with SSH"
  type        = string
  default     = ""
}
