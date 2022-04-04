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
  #   for_each = toset(var.repository_list)
  #    name = "${aws_ecr_repository.repository.repository_url}:<imageNameVar>"
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