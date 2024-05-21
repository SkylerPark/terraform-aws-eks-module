module "aws_auth" {
  source = "../../modules/aws-auth"
  map_users = [
    {
      iam_user = "parksm"
      username = "parksm"
      groups   = []
    }
  ]
}
