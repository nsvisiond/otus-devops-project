resource "yandex_compute_instance" "master" {
  count    = var.instance_size_master
  name     = "master-${count.index + 1}"
  hostname = "master-${count.index + 1}"

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
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private-subnet.id
    nat       = false
  }
}

resource "null_resource" "deploy_master" {
   triggers = {
     addrs = join(",", local.ips),
   }

  depends_on = [local_file.generate_inventory]
}
