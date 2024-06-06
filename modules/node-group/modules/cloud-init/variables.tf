variable "hostname" {
  type        = string
  description = "Hostname of the node"
}

variable "domain" {
  type        = string
  description = "Domain of the node"
}

variable "write_files" {
  type = list(object({
    path    = string
    content = string
  }))
  description = "Files to be created on the server."
}

variable "ssh_import_id" {
  type        = list(string)
  description = "SSH keys to import to the node"
  default     = ["gh:appkins"]
  nullable    = false
}

variable "runcmd" {
  type        = list(string)
  description = "Commands to be executed on the server."
}

variable "apt_sources" {
  type = map(object({
    source = string
    key    = string
  }))
  description = "APT sources to add to the node"
}
