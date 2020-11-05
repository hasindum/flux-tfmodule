output "namespaces" {
  value       = [for x in kubernetes_namespace.ns : x["id"]]
  description = "List of namespaces created"
}

output "waited_for" {
  value = var.wait_for
  description = "Dependencies that had to be waited for"
}