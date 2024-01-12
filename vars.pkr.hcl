variable "api_token" {
  description = "My digital ocean token"
  type        = string
  default     = env("DIGTALOCEAN_TOKEN")
}

variable "droplet_name" {
  description = "The name of my droplet"
  type        = string
  default     = "ubuntu-nginx-test"
}

variable "image" {
  description = "The desired image for packer"
  type        = string
  default     = "ubuntu-22-04-x64"
}

variable "region" {
  description = "Desired region"
  type        = string
  default     = "nyc1"
}

variable "size" {
  description = "Desired cpu and ram size for the droplet"
  type        = string
  default     = "s-1vcpu-1gb-amd"
}

variable "snapshot_name" {
  description = "Name of the snapshot"
  type        = string
  default     = "ubuntu-nginx-std"
}

variable "snapshot_regions" {
  description = "The snapshot regions"
  type        = list(string)
  default     = ["nyc1", "nyc3"]
}

variable "ssh_username" {
  description = "Digital ocean default user"
  type        = string
  default     = "root"
}

variable "tags" {
  description = "My favourite tags"
  type        = list(string)
  default     = ["dev", "packer", "cloud-team", "ubuntu", "2004"]
}
