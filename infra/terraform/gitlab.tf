resource "yandex_compute_instance" "gitlab" {
  name     = "gitlab"
  hostname = "gitlab"

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }

  resources {
    cores  = 8
    memory = 8
  }

  boot_disk {
    initialize_params {
      image_id = var.gitlab_image_id
      size     = 30
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private-subnet.id
    nat       = true
  }
}