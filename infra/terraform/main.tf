data "yandex_compute_image" "ubuntu_image" {
  family = "ubuntu-1804-lts"
}

provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}

locals {
  names                  = yandex_compute_instance.master[*].name
  ips                    = yandex_compute_instance.master[*].network_interface.0.ip_address
  names_node             = yandex_compute_instance.node[*].name
  ips_node               = yandex_compute_instance.node[*].network_interface.0.ip_address
  names_gitlab           = yandex_compute_instance.gitlab[*].name
  ips_gitlab             = yandex_compute_instance.gitlab[*].network_interface.0.ip_address
  names_docker_runner    = yandex_compute_instance.docker_runner[*].name
  ips_docker_runner      = yandex_compute_instance.docker_runner[*].network_interface.0.ip_address
}

resource "local_file" "generate_inventory" {
  content = templatefile("hosts.tpl", {
    names                  = local.names,
    addrs                  = local.ips,
    names_node             = local.names_node,
    addrs_node             = local.ips_node,
    names_gitlab           = local.names_gitlab,
    addrs_gitlab           = local.ips_gitlab,
    names_docker_runner    = local.names_docker_runner,
    addrs_docker_runner    = local.ips_docker_runner
  })
  filename = "../ansible/hosts"

  provisioner "local-exec" {
    command = "chmod a-x ../ansible/hosts"
  }

  provisioner "local-exec" {
    when       = destroy
    command    = "mv ../ansible/hosts ../ansible/hosts.backup"
    on_failure = continue
  }
}
