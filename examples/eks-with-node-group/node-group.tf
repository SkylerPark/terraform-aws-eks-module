data "aws_ami" "eks_default" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amazon-eks-node-${local.eks_version}-v*"]
  }
}

data "aws_ami" "eks_default_arm" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amazon-eks-arm64-node-${local.eks_version}-v*"]
  }
}

module "ssh_key" {
  source             = "git::https://github.com/SkylerPark/terraform-aws-ec2-module.git//modules/key-pair/?ref=tags/1.2.1"
  name               = "parksm-test"
  create_private_key = true
}

module "node_group_role" {
  source = "git::https://github.com/SkylerPark/terraform-aws-iam-module.git//modules/iam-role/?ref=tags/1.0.1"
  name   = "${local.eks_name}-node-role"
  trusted_service_policies = [
    {
      services = ["ec2.amazonaws.com"]
    }
  ]
  policies = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ]
  force_detach_policies = true
  instance_profile = {
    enabled = true
  }
}

module "node_group" {
  source           = "../../modules/node-group"
  name             = "${module.cluster.name}-node-group"
  cluster_name     = module.cluster.name
  instance_ami     = data.aws_ami.eks_default_arm.id
  instance_type    = "t4g.medium"
  instance_key     = module.ssh_key.name
  instance_profile = module.node_group_role.instance_profile.name

  spot_enabled = true

  security_groups = [module.node_sg.id]

  subnets = module.subnet_group["parksm-private-subnet"].ids

  min_size     = 2
  max_size     = 10
  desired_size = 2


  metadata_options = {
    http_endpoint_enabled = true
    http_tokens_enabled   = true
    instance_tags_enabled = true
  }

  root_volume_encryption_enabled = true
  root_volume_type               = "gp3"
  root_volume_size               = 50
}
