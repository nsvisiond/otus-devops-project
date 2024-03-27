resource "yandex_lb_target_group" "project_app_tg" {
  name      = "project-app-tg"
  region_id = "ru-central1"

  dynamic target {
    for_each = yandex_compute_instance.node.*.network_interface.0.ip_address
    content {
      subnet_id = yandex_vpc_subnet.private-subnet.id
      address   = target.value
    }
  }
}

resource "yandex_lb_target_group" "project_monit_tg" {
  name      = "project-monit-tg"
  region_id = "ru-central1"


  dynamic target {
    for_each = yandex_compute_instance.master.*.network_interface.0.ip_address
    content {
      subnet_id = yandex_vpc_subnet.private-subnet.id
      address   = target.value
    }
  }

}

resource "yandex_lb_network_load_balancer" "project_app_lb" {
  name = "project-app-lb"

  listener {
    name        = "project-app-listener"
    port        = 80
    target_port = 8000
    external_address_spec {
      address = yandex_vpc_address.balancer.external_ipv4_address.0.address
      ip_version = "ipv4"
    }
  }

  listener {
    name        = "project-rabbitmq-listener"
    port        = 15672
    target_port = 15672
    external_address_spec {
      address = yandex_vpc_address.balancer.external_ipv4_address.0.address
      ip_version = "ipv4"
    }
  }

    listener {
    name        = "project-monitoring-listener"
    port        = 9090
    target_port = 9090
    external_address_spec {
      address = yandex_vpc_address.balancer.external_ipv4_address.0.address
      ip_version = "ipv4"
    }
  }

    listener {
    name        = "project-grafana-listener"
    port        = 3000
    target_port = 3000
    external_address_spec {
      address = yandex_vpc_address.balancer.external_ipv4_address.0.address
      ip_version = "ipv4"
    }
  }

    listener {
    name        = "project-cadvisor-listener"
    port        = 8080
    target_port = 8080
    external_address_spec {
      address = yandex_vpc_address.balancer.external_ipv4_address.0.address
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.project_app_tg.id

    healthcheck {
      name = "app-http-hc"
      http_options {
        port = 8000
        path = "/"
      }
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.project_monit_tg.id

    healthcheck {
      name = "monit-http-hc"
      http_options {
        port = 3000
        path = "/login"
      }
    }
  }

}
