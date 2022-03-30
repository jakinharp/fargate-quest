variable "profile" {
  type    = string
  default = "default"
}

variable "region-main" {
  type    = string
  default = "us-east-1"
}

variable "repository-list" {
  description = "List of repository names"
  type        = list(any)
  default     = ["rearc-quest"]
}

variable "external-ip" {
  type    = string
  default = "0.0.0.0/0"
}

variable "app-port" {
  default     = "80"
  description = "portexposed on the docker image"
}

variable "app-image" {
  default     = "node:latest"
  description = "docker image to run in this ECS cluster"
}

#Need at least 2 subnets in 2 AZs for ALB to work properly
variable "az-count" {
  default     = "2"
  description = "number of AZs in active region"
}

#Need at least as many containers as you have AZs
variable "app-count" {
  default     = "2"
  description = "numer of docker containers to run"
}

variable "health-check-path" {
  default = "/"
}

variable "fargate-cpu" {
  default     = "1024"
  description = "fargate instacne CPU units to provision,my requirent 1 vcpu so gave 1024"
}

variable "fargate-memory" {
  default     = "2048"
  description = "Fargate instance memory to provision (in MiB) not MB"
}