provider "vsphere" {
  user                 = var.username
  password             = var.password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = true
}

module "content-item" {
  source = "./modules/content-library"
  dc_name = var.dc_name
  content_library_name = var.content_library_name
  importer_name = var.importer_name
}

module "vm" {
  source = "./modules/vm"
  cluster = var.cluster
  datastore = var.datastore
  dc_name = var.dc_name
  network = var.network
}