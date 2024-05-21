module "addon" {
  source   = "../../modules/addon"
  for_each = toset(["coredns", "kube-proxy", "vpc-cni"])

  name               = each.key
  addon_version_type = "latest"

  cluster_name    = local.eks_cluster_name
  cluster_version = local.eks_version
}
