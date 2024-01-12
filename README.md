# Packer DigitalOcean Image Creation

This Git repository provides a practical example and template for using [Packer](https://www.packer.io/) with the DigitalOcean plugin to create reusable machine images. The main focus is on streamlining the process of image creation and provisioning.

## Prerequisites

Before you begin, ensure you have the following:

- [Packer](https://www.packer.io/) installed on your machine.
- A valid DigitalOcean account.
- An API token for DigitalOcean with the necessary permissions.

## Getting Started

Follow these steps to use Packer and the DigitalOcean plugin to create a machine image:

1. Clone this repository:

    ```bash
    git clone https://github.com/adaanene/packer_tutorial.git
    ```

2. Navigate to the repository directory:

    ```bash
    cd packer_tutorial
    ```

3. Customize the `variables.json` file to set your DigitalOcean API token and other configuration options.

4. Run Packer to create the machine image: build steps can be found [here](https://developer.hashicorp.com/packer/tutorials/aws-get-started/aws-get-started-build-image)

## Configuration

### Packer Configuration (main.pkr.hcl)

The `main.pkr.hcl` file contains the Packer configuration, including the DigitalOcean plugin setup, source configuration, and build steps.

```hcl
# Packer configuration for DigitalOcean
packer {
  required_plugins {
    digitalocean = {
      version = ">= 1.0.4"
      source  = "github.com/digitalocean/digitalocean"
    }
  }
}

# Local variables
locals {
  timestamp = formatdate("YYYY-MM", timestamp())
}

# DigitalOcean source configuration
source "digitalocean" "this" {
  api_token        = "${var.api_token}"
  droplet_name     = "${var.droplet_name}-${local.timestamp}"
  image            = "${var.image}"
  region           = "${var.region}"
  size             = "${var.size}"
  snapshot_name    = "${var.snapshot_name}-${local.timestamp}"
  snapshot_regions = "${var.snapshot_regions}"
  ssh_username     = "${var.ssh_username}"
  tags             = "${var.tags}"
}

# Build configuration
build {
  sources = ["source.digitalocean.this"]

  # Shell provisioners
  provisioner "shell" {
    inline = [
      "groupadd -g 1001 ubuntu",
      "useradd ubuntu -m -g 1001 -u 1001",
      "sudo apt update"
    ]
  }

  provisioner "shell" {
    script = "./scripts/bootstrap.sh"
  }
}
```

### Variables (vars.pkr.hcl)

Customize the variables in the `vars.pkr.hcl` file to suit your environment and requirements.

```
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
```

## Additional Information

- For more information on Packer, refer to the [Packer documentation](https://www.packer.io/docs/).
- DigitalOcean plugin documentation can be found [here](https://www.packer.io/docs/builders/digitalocean).