data "vsphere_datacenter" "datacenter" {
  name = var.dc_name
}

data "vsphere_content_library" "content_library" {
  name = var.content_library_name
}

resource "vsphere_content_library_item" "content_library_ubuntu_22_04_3_item" {
  name        = "ubuntu-22.04.3-live-server-amd64.iso"
  description = "Imported by ${var.importer_name} on ${formatdate("DD MMM YYYY hh:mm ZZZ", timestamp())}"
  file_url    = "https://releases.ubuntu.com/22.04.3/ubuntu-22.04.3-live-server-amd64.iso"
  library_id  = data.vsphere_content_library.content_library.id
}