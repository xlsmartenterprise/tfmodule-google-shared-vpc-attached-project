# tfmodule-google-shared-vpc-attached-project

Terraform module for attaching service projects to a Google Cloud Shared VPC host project. This module simplifies the management of Shared VPC configurations by providing a flexible, map-based approach to attaching multiple service projects to a host project.

## Features

- **Multi-Project Support**: Attach multiple service projects to a single Shared VPC host using a map-based configuration
- **Flexible Configuration**: Use custom keys to organize and identify service projects
- **Comprehensive Outputs**: Detailed project mappings and simple lists for easy integration with other modules
- **For_each Implementation**: Efficient resource management using Terraform's for_each meta-argument
- **Simple Interface**: Minimal required inputs with sensible defaults

## Usage

### Basic Example
```hcl
module "shared_vpc_attachment" {
  source = "git::https://github.com/your-org/tfmodule-google-shared-vpc-attached-project.git?ref=v1.0.0"

  host_project_id = "my-host-project"

  service_projects = {
    dev = {
      project_id = "my-dev-project"
    }
    staging = {
      project_id = "my-staging-project"
    }
  }
}
```

### Multiple Service Projects Example
```hcl
module "shared_vpc_attachment" {
  source = "git::https://github.com/your-org/tfmodule-google-shared-vpc-attached-project.git?ref=v1.0.0"

  host_project_id = "central-networking-host"

  service_projects = {
    application_dev = {
      project_id = "app-dev-project-123"
    }
    application_staging = {
      project_id = "app-staging-project-456"
    }
    application_prod = {
      project_id = "app-prod-project-789"
    }
    data_platform = {
      project_id = "data-platform-project-001"
    }
    analytics = {
      project_id = "analytics-project-002"
    }
  }
}

# Reference outputs
output "attached_projects" {
  description = "List of all attached service projects"
  value       = module.shared_vpc_attachment.service_project_ids
}

output "project_details" {
  description = "Detailed information about attached projects"
  value       = module.shared_vpc_attachment.service_projects
}
```

### Enterprise Multi-Environment Example
```hcl
# Host project module
module "shared_vpc_host" {
  source = "git::https://github.com/your-org/tfmodule-google-project.git?ref=v1.0.0"

  project_name = "shared-vpc-host"
  project_id   = "org-shared-vpc-host"
  folder_id    = var.network_folder_id
}

# Attach service projects across multiple environments
module "shared_vpc_service_attachment" {
  source = "git::https://github.com/your-org/tfmodule-google-shared-vpc-attached-project.git?ref=v1.0.0"

  host_project_id = module.shared_vpc_host.project_id

  service_projects = {
    # Development environment
    app_dev = {
      project_id = "app-dev-123456"
    }
    db_dev = {
      project_id = "db-dev-123456"
    }
    
    # Staging environment
    app_staging = {
      project_id = "app-staging-789012"
    }
    db_staging = {
      project_id = "db-staging-789012"
    }
    
    # Production environment
    app_prod = {
      project_id = "app-prod-345678"
    }
    db_prod = {
      project_id = "db-prod-345678"
    }
    
    # Shared services
    monitoring = {
      project_id = "monitoring-shared-111111"
    }
    logging = {
      project_id = "logging-shared-222222"
    }
  }
}

# Output for use in subnet IAM bindings
output "all_service_projects" {
  description = "All service projects attached to Shared VPC"
  value       = module.shared_vpc_service_attachment.service_project_ids
}

output "host_project" {
  description = "The Shared VPC host project"
  value       = module.shared_vpc_service_attachment.host_project_id
}
```

### Dynamic Service Project Attachment Example
```hcl
# Define service projects dynamically
locals {
  environments = ["dev", "staging", "prod"]
  applications = ["frontend", "backend", "database"]
  
  # Generate service projects map dynamically
  service_projects = {
    for combo in setproduct(local.environments, local.applications) :
    "${combo[0]}-${combo[1]}" => {
      project_id = "myorg-${combo[0]}-${combo[1]}-${random_id.project_suffix[combo].hex}"
    }
  }
}

# Random suffix for project IDs
resource "random_id" "project_suffix" {
  for_each    = toset([for combo in setproduct(local.environments, local.applications) : "${combo[0]}-${combo[1]}"])
  byte_length = 4
}

module "shared_vpc_attachment" {
  source = "git::https://github.com/your-org/tfmodule-google-shared-vpc-attached-project.git?ref=v1.0.0"

  host_project_id  = "shared-vpc-host-project"
  service_projects = local.service_projects
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| host_project_id | The ID of the host project which hosts the shared VPC | `string` | n/a | yes |
| service_projects | Map of service projects to attach to the shared VPC host. Key is a unique identifier, value contains project details | `map(object({project_id = string}))` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| service_projects | Map of attached service projects with detailed information (host_project, service_project, id) |
| service_project_ids | List of attached service project IDs |
| host_project_id | The host project ID |

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5.0 |
| google | >= 7.0.0, < 8.0.0 |
| google-beta | >= 7.0.0, < 8.0.0 |

## Resources Created

This module creates the following resources:

- `google_compute_shared_vpc_service_project`: Attaches each service project to the Shared VPC host

## Permissions Required

To use this module, the service account or user running Terraform must have the following permissions:

### On the Host Project:
- `compute.organizations.enableXpnResource` (granted by `Compute Shared VPC Admin` role)

### On the Service Project:
- `compute.projects.get`
- `resourcemanager.projects.get`

**Recommended IAM Roles:**
- Host Project: `roles/compute.xpnAdmin`
- Service Project: `roles/compute.networkUser` or `roles/compute.xpnAdmin`

## Notes

- The host project must already be configured as a Shared VPC host project
- Service projects must exist before running this module
- Each service project can only be attached to one Shared VPC host
- Removing a service project from the configuration will detach it from the Shared VPC
- The module uses `for_each` to manage multiple service projects efficiently

## Changelog

See [CHANGELOG.md](./CHANGELOG.md) for version history and changes.