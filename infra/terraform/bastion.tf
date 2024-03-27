resource "yandex_compute_instance" "bastion" {
  count    = var.instance_size_bastion
  name     = "bastion"
  hostname = "bastion"

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_image.id
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }
}
