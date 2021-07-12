variable "name" {
  description = "The name to apply to the resources"
  type    = string
  default = "bigbang-dev"
}

variable "kubeconfig_path" {
  description = "Remote path to kubeconfig"
  type = string
}