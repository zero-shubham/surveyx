resource "vultr_kubernetes" "surveyx_k8s_cluster" {
  region  = "ewr"
  label   = "surveyx-cluster"
  version = "v1.32.4+1"

  node_pools {
    node_quantity = 2
    plan          = "vc2-2c-4gb"
    label         = "surveyx"
    auto_scaler   = true
    min_nodes     = 1
    max_nodes     = 3
  }
}

resource "time_sleep" "wait_120_seconds" {
  create_duration  = "120s"
  destroy_duration = "120s"
}

resource "time_sleep" "wait_60_seconds" {
  create_duration  = "120s"
  destroy_duration = "120s"
}

resource "vultr_block_storage" "surveyx_blockstorage_1" {
  label                = "surveyx-block-storage-1"
  size_gb              = 10
  region               = "ewr"
  attached_to_instance = vultr_kubernetes.surveyx_k8s_cluster.node_pools[0].nodes[0].id

  depends_on = [vultr_kubernetes.surveyx_k8s_cluster, time_sleep.wait_60_seconds]
}


resource "vultr_block_storage" "surveyx_blockstorage_2" {
  label                = "surveyx-block-storage-2"
  size_gb              = 10
  region               = "ewr"
  attached_to_instance = vultr_kubernetes.surveyx_k8s_cluster.node_pools[0].nodes[0].id

  depends_on = [vultr_kubernetes.surveyx_k8s_cluster, time_sleep.wait_120_seconds]
}

# resource "vultr_firewall_group" "my_firewallgroup" {
#   description = "base firewall"
# }

# resource "vultr_firewall_rule" "my_firewallrule" {
#   firewall_group_id = vultr_firewall_group.my_firewallgroup.id
#   protocol          = "tcp"
#   ip_type           = "v4"
#   subnet            = vultr_kubernetes.surveyx_k8s_cluster.cluster_subnet
#   subnet_size       = 0
#   port              = "80"
#   notes             = "surveyx allow 80"

#   depends_on = [vultr_kubernetes.surveyx_k8s_cluster, vultr_firewall_group.my_firewallgroup]
# }
