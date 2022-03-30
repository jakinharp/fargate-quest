provider "aws" {
  profile = var.profile
  region  = var.region-main
  alias   = "region-main"
}

provider "docker" {
  registry_auth {
    address  = local.aws_ecr_url
    username = data.aws_ecr_authorization_token.token.user_name
    password = data.aws_ecr_authorization_token.token.password
  }
}
