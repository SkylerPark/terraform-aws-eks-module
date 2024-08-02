module "fargate_role" {
  source = "git::https://github.com/SkylerPark/terraform-aws-iam-module.git//modules/iam-role/?ref=tags/1.0.1"
  name   = "${local.eks_name}-fargate-role"
  trusted_service_policies = [
    {
      services = ["eks-fargate-pods.amazonaws.com"]
    }
  ]
  policies = [
    "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  ]
  force_detach_policies = true
}

module "fargate" {
  source   = "../../modules/fargate-profile"
  for_each = toset(["karpenter", "kube-system"])

  name         = each.key
  cluster_name = module.cluster.name

  subnets  = module.subnet_group["parksm-private-subnet"].ids
  iam_role = module.fargate_role.arn

  selectors = [
    {
      namespace = each.key
    }
  ]
}
