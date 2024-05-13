variable "provisioner" {
  description = <<EOF
  (필수) karpenter provisioner 설정 `provisioner` 블록 내용.
    (필수) `name` - provisioner 리소스의 이름.
    (필수) `requirements` - karpenter provisioning 할때 인스턴스 설정값의 집합 (list(any)).
    (선택) `provider_ref` - provider ref 설정 map(string).
    (선택) `consolidation` - karpenter 안정성 및 성능 향상에 대한 옵션 map(string).
  EOF
  type = object({
    name          = string
    requirements  = list(any)
    provider_ref  = map(string)
    consolidation = map(string)
  })
  default  = {}
  nullable = false
}

variable "aws_node_template" {
  description = <<EOF
  (필수) karpenter aws node template 설정 `aws_node_template` 블록 내용.
    (필수) `name` - aws node template 리소스의 이름.
    (필수) `subnet_selector` - node 가 생성시 subnet 을 참고하는 key value. (map(string))
    (필수) `security_group_selector` - node 가 생성시 security group 을 참고하는 key value.(map(string)).
    (필수) `ami_family` - node 생성시 ami family 참고 값.
    (필수) `block_device_mappings` - node 생성시 디스크에 대한 설정값 list(any).
    (선택) `tags` - node 생성시 tag 설정값 map(string).
  EOF
  type = object({
    name                    = string
    subnet_selector         = map(string)
    security_group_selector = map(string)
    ami_family              = string
    block_device_mappings   = list(any)
    tags                    = map(string)
  })
}
