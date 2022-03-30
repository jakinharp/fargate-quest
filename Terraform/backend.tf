terraform {
  required_version = ">=1.1.7"
  backend "s3" {
    region  = "us-east-1"
    profile = "default"
    key     = "terraformstatefile"
    bucket  = "rearc-project-bucket-8675"
  }
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = ">=2.16.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">=4.8.0"
    }
  }
}
