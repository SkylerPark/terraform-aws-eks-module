data "aws_eks_cluster_auth" "this" {
  name = module.cluster.name
}

provider "helm" {
  kubernetes {
    host                   = module.cluster.endpoint
    cluster_ca_certificate = base64decode(module.cluster.ca_cert)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}

provider "kubectl" {
  host                   = module.cluster.endpoint
  cluster_ca_certificate = base64decode(module.cluster.ca_cert)
  token                  = data.aws_eks_cluster_auth.this.token
  load_config_file       = false
}
