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