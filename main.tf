resource "google_compute_shared_vpc_service_project" "service_projects" {
  for_each          = var.service_projects
  host_project      = var.host_project_id
  service_project   = each.value.project_id
}