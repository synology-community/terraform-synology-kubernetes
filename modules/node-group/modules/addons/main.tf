resource "terraform_data" "manifests" {
  input = {
    files = local.addon_files
  }
}
