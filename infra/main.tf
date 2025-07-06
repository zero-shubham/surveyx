

resource "vultr_kubernetes" "surveyx_k8s_cluster" {
  region  = "ewr"
  label   = "surveyx-cluster"
  version = "v1.32.4+1"

  node_pools {
    node_quantity = 3
    plan          = "vc2-4c-8gb"
    label         = "surveyx"
    auto_scaler   = true
    min_nodes     = 1
    max_nodes     = 3
  }
}


resource "null_resource" "save_kubeconfig" {

  provisioner "local-exec" {
    command = <<-EOF
      mkdir -p ~/.kube
      
      if [ -f ~/.kube/config ]; then
        cp ~/.kube/config ~/.kube/config.backup.$(date +%Y%m%d-%H%M%S)
        echo "Backed up existing kubeconfig"
      fi
      
      echo '${vultr_kubernetes.surveyx_k8s_cluster.kube_config}' | base64 --decode > ~/.kube/config
      chmod 600 ~/.kube/config
      
      echo "Kubeconfig saved to ~/.kube/config"
      
      kubectl cluster-info --request-timeout=10s || echo "Cluster not ready yet"
    EOF
  }

  depends_on = [vultr_kubernetes.surveyx_k8s_cluster, time_sleep.wait_30_seconds]
}

resource "time_sleep" "wait_30_seconds" {
  create_duration  = "30s"
  destroy_duration = "10s"
}

