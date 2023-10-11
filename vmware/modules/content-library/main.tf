data "vsphere_datacenter" "datacenter" {
  name = var.dc_name
}

data "vsphere_content_library" "content_library" {
#  name = "clb-01"
  name = var.
}

resource "vsphere_content_library_item" "content_library_item" {
  name        = "ovf-linux-ubuntu-server-lts"
  description = "Ubuntu Server LTS OVF Template"
  file_url    = "https://releases.example.com/ubuntu/ubuntu/ubuntu-live-server-amd64.ovf"
  library_id  = data.vsphere_content_library.content_library.id
}