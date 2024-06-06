variable "secrets" {
  type = list(object({
    name      = string
    namespace = string
    type      = string
    data      = map(string)
  }))
  description = "Secrets to create in the cluster."
}
