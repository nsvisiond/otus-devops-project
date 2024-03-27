resource "yandex_vpc_route_table" "private-nat-route" {
  network_id = var.network_id
  name = "private-nat-route"

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = yandex_compute_instance.nat-vm.network_interface[0].ip_address
  }
}

resource "yandex_vpc_subnet" "private-subnet" {
  name = "private-subnet"
  description = "[Terraform] NATed private subnet"
  v4_cidr_blocks = ["10.130.99.0/24"]
  zone           = var.zone
  network_id     = var.network_id
  route_table_id = yandex_vpc_route_table.private-nat-route.id
}
