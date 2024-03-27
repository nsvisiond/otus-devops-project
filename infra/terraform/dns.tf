resource "yandex_dns_zone" "otus-project-zone" {
  name        = "otus-project-zone"
  description = "otus-project-zone"
  zone        = "nsvision.ru."
  public      = true
}

resource "yandex_vpc_address" "balancer" {
  name = "balancer"
  external_ipv4_address {
    zone_id = var.zone
  }
}


resource "yandex_dns_recordset" "gitlab" {
  zone_id = yandex_dns_zone.otus-project-zone.id
  name    = var.gitlab_domain
  type    = "A"
  ttl     = 60
  data    = [yandex_compute_instance.gitlab.network_interface.0.nat_ip_address]
}

resource "yandex_dns_recordset" "app" {
  zone_id = yandex_dns_zone.otus-project-zone.id
  name    = var.app_domain
  type    = "A"
  ttl     = 60
  data    = [yandex_vpc_address.balancer.external_ipv4_address.0.address]
}

resource "yandex_dns_recordset" "bastion" {
  zone_id = yandex_dns_zone.otus-project-zone.id
  name    = var.bastion_domain
  type    = "A"
  ttl     = 60
  data    = [yandex_compute_instance.bastion[0].network_interface.0.nat_ip_address]
}