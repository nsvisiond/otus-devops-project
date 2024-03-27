resource "yandex_compute_instance" "node" {
  count    = var.instance_size_node
  name     = "node-${count.index + 1}"
  hostname = "node-${count.index + 1}"

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }

  resources {
    cores  = 4
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_image.id
      size = "10"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private-subnet.id
    nat       = false
  }
}

resource "null_resource" "deploy_node" {
  provisioner "local-exec" {
  working_dir = "../ansible/"
  command = "sleep 60 && ansible-playbook install_docker_node.yml"
  }

  triggers = {
    addrs = join(",", local.ips_node),
  }

  depends_on = [
    local_file.generate_inventory,
    yandex_compute_instance.master
  ]
}
