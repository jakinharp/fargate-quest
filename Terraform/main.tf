## Create ECR repo
resource "aws_ecr_repository" "repository" {
  name = "rearc-quest"
}

### Create ECR repo
#resource "aws_ecr_repository" "repository" {
#  for_each = toset(var.repository_list)
#  name     = each.key
#}

## Build docker image and push to ECR
resource "docker_registry_image" "node" {
  ##   for_each = toset(var.repository_list)
  ##   name     = "${aws_ecr_repository.repository[each.key].repository_url}:latest"

  #    name = "233580134604.dkr.ecr.us-east-1.amazonaws.com/rearc-quest"
  #    name = "${aws_ecr_repository.repository.repository_url}:latest"
  name = "${aws_ecr_repository.repository.repository_url}:node"

  build {
    context    = "${path.cwd}/rearc-quest/"
    dockerfile = "./Dockerfile"
  }

  ### REMOVE LIFECYCLE IF NEED NEW IMAGE ###
  lifecycle {
    ignore_changes = [
      name,
    ]
  }
}