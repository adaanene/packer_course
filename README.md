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
    git clone https://github.com/your-username/your-repo.git
    ```

2. Navigate to the repository directory:

    ```bash
    cd your-repo
    ```

3. Customize the `variables.json` file to set your DigitalOcean API token and other configuration options.

4. Run Packer to create the machine image:

    ```bash
    packer build -var-file=variables.json main.pkr.hcl
    ```

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

### Variables (variables.json)

Customize the variables in the `variables.json` file to suit your environment and requirements.

```json
{
  "api_token": "your-digitalocean-api-token",
  "droplet_name": "packer-droplet",
  "image": "ubuntu-20-04-x64",
  "region": "nyc1",
  "size": "s-1vcpu-1gb",
  "snapshot_name": "packer-snapshot",
  "snapshot_regions": ["nyc1", "sfo2"],
  "ssh_username": "ubuntu",
  "tags": ["packer", "image"]
}
```

## Additional Information

- For more information on Packer, refer to the [Packer documentation](https://www.packer.io/docs/).
- DigitalOcean plugin documentation can be found [here](https://www.packer.io/docs/builders/digitalocean).