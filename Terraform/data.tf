data "aws_caller_identity" "current" {}

data "aws_ecr_authorization_token" "token" {}

#Get all available AZ's in VPC for main region
data "aws_availability_zones" "azs" {
  provider = aws.region-main
  state    = "available"
}
