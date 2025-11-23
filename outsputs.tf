output "service_projects" {
  description = "Map of attached service projects"
  value = {
    for k, v in google_compute_shared_vpc_service_project.service_projects : k => {
      host_project    = v.host_project
      service_project = v.service_project
      id              = v.id
    }
  }
}

output "service_project_ids" {
  description = "List of attached service project IDs"
  value       = [for v in google_compute_shared_vpc_service_project.service_projects : v.service_project]
}

output "host_project_id" {
  description = "The host project ID"
  value       = var.host_project_id
}