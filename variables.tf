variable "host_project_id" {
  description = "The ID of the host project which hosts the shared VPC"
  type        = string
}

variable "service_projects" {
  description = "Map of service projects to attach to the shared VPC host. Key is a unique identifier, value contains project details"
  type = map(object({
    project_id = string
  }))
  default = {}
}