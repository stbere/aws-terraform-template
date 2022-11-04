variable "env" {
  type        = string
  description = "environment variable parameter"
}

variable "vpcs" {
  description = "List of VPCs that needs to be created"
  type        = list(any)
}