output "name" {
  description = "node group 이름."
  value       = var.name
}

output "min_size" {
  description = "EKS cluster node group 최소 인스턴스 수.."
  value       = aws_autoscaling_group.this.min_size
}

output "max_size" {
  description = "EKS cluster node group 최대 인스턴스 수."
  value       = aws_autoscaling_group.this.max_size
}

output "desired_size" {
  description = "EKS cluster node group 실행 할 인스턴스 수."
  value       = aws_autoscaling_group.this.desired_capacity
}

output "instance_ami" {
  description = "EKS cluster node group AMI."
  value       = aws_launch_template.this.image_id
}

output "instance_type" {
  description = "EKS cluster node group 인스턴스 type."
  value       = aws_launch_template.this.instance_type
}

output "instance_key" {
  description = "EKS cluster node group SSH Key 이름."
  value       = aws_launch_template.this.key_name
}

output "instance_profile" {
  description = "EKS cluster node group 에 IAM 인스턴스 profile 이름."
  value       = var.instance_profile
}

output "security_groups" {
  description = "Node Group 에 연결할 추가 보안 그룹 ID 목록."
  value       = aws_launch_template.this.network_interfaces[0].security_groups
}

output "asg_id" {
  description = "ASG(Auto-Scaling Group) ID."
  value       = aws_autoscaling_group.this.id
}

output "asg_arn" {
  description = "ASG(Auto-Scaling Group) ARN."
  value       = aws_autoscaling_group.this.arn
}

output "asg_name" {
  description = "ASG(Auto-Scaling Group) 이름."
  value       = aws_autoscaling_group.this.name
}
