module "cloud_init" {
  source = "../cloud-init"

  hostname = var.name
  domain   = var.domain

  apt_sources   = var.apt_sources
  ssh_import_id = var.ssh_import_id
  write_files   = local.write_files
  runcmd        = local.init_cmd
}

resource "terraform_data" "cloud_init" {
  input = {
    user_data = module.cloud_init.rendered
  }
}

resource "synology_filestation_cloud_init" "default" {
  path           = "/vm/images/${var.name}_cloudinit.iso"
  user_data      = terraform_data.cloud_init.output.user_data
  meta_data      = local.meta_data
  network_config = local.network_config
}

resource "synology_virtualization_image" "cloud_init" {
  name       = "${var.name}_cloudinit"
  path       = synology_filestation_cloud_init.test.path
  image_type = "iso"
  auto_clean = true

  depends_on = [synology_filestation_cloud_init.test]

  lifecycle {
    replace_triggered_by = [synology_filestation_cloud_init.test]
  }
}

resource "synology_virtualization_guest" "default" {
  name         = var.name
  storage_name = "default"

  vcpu_num  = 4
  vram_size = 8192

  network {
    name = "default"
  }

  iso {
    image_id = synology_virtualization_image.cloud_init.id
  }

  disk {
    image_id = var.image_id
  }

  run = true

  lifecycle {
    replace_triggered_by = [synology_filestation_cloud_init.default]
  }
}
