output "k8s_ip" {
  value = vultr_kubernetes.surveyx_k8s_cluster.ip
}

output "kubeconfig_path" {
  value       = "~/.kube/config"
  description = "Path to the kubeconfig file"
}

