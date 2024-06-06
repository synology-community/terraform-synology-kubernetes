variable "ssh" {
  description = "SSH connection details"
  type = object({
    user = optional(string, null)
    host = optional(string, null)
  })
  default = {}
}
