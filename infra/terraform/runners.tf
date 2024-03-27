resource "yandex_compute_instance" "docker_runner" {
  #count    = var.instance_size_docker_runner
  name     = "docker-runner"
  hostname = "docker-runner"

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
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private-subnet.id
    nat       = false
  }
}

resource "null_resource" "deploy_docker_runner" {
  provisioner "local-exec" {
  working_dir = "../ansible/"
  command = "sleep 60 && ansible-playbook install_docker_runner.yml"
  }

   triggers = {
     addrs = join(",", local.ips_docker_runner),
   }

    depends_on = [
    local_file.generate_inventory
  ]
}
