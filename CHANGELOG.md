# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-11-23

### Added
- Initial release of Shared VPC Service Project attachment module
- Support for attaching multiple service projects to a Shared VPC host project
- Map-based configuration for flexible service project management
- Comprehensive outputs including individual project details and aggregated lists
- Support for Terraform >= 1.5.0
- Support for Google Provider >= 7.0.0, < 8.0.0

### Features
- Automated attachment of service projects to Shared VPC host
- For_each loop implementation for managing multiple service projects
- Structured output with detailed project mappings
- Host project ID passthrough for reference

### Outputs
- `service_projects`: Detailed map of all attached service projects with host, service project IDs, and resource IDs
- `service_project_ids`: Simple list of attached service project IDs
- `host_project_id`: The host project ID for reference

### Requirements
- Terraform >= 1.5.0
- Google Provider >= 7.0.0, < 8.0.0
- Google Beta Provider >= 7.0.0, < 8.0.0