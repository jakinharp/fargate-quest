variable "profile" {
  type    = string
  default = "default"
}

variable "region-main" {
  type    = string
  default = "us-east-1"
}

variable "repository_list" {
  description = "List of repository names"
  type        = list(any)
  default     = ["rearc-quest"]
}

variable "external_ip" {
  type    = string
  default = "0.0.0.0/0"
}

variable "app_port" {
  default     = "80"
  description = "portexposed on the docker image"
}

variable "ecs_task_execution_role" {
  default     = "myECcsTaskExecutionRole"
  description = "ECS task execution role name"
}

variable "app_image" {
  default     = "node:latest"
  description = "docker image to run in this ECS cluster"
}

#Need at least as many containers as you have AZs
variable "app_count" {
  default     = "2"
  description = "numer of docker containers to run"
}

variable "health_check_path" {
  default = "/"
}

variable "fargate_cpu" {
  default     = "1024"
  description = "fargate instacne CPU units to provision,my requirent 1 vcpu so gave 1024"
}

variable "fargate_memory" {
  default     = "2048"
  description = "Fargate instance memory to provision (in MiB) not MB"
}