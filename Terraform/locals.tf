locals {
  tags = {
    created_by = "terraform"
  }

  aws_ecr_url = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region-main}.amazonaws.com"
  # aws_ecr_url = data.aws_ecr_authorization_token.token.proxy_endpoint
}
