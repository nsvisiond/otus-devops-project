output "external_ip_address_lb" {
  value = yandex_lb_network_load_balancer.project_app_lb.listener.*.external_address_spec[0].*.address
}
output "external_port_lb" {
  value = yandex_lb_network_load_balancer.project_app_lb.listener.*.port
}
output "target_port_lb" {
  value = yandex_lb_network_load_balancer.project_app_lb.listener.*.target_port
}
output "external_ip_address_bastion" {
  value = yandex_compute_instance.bastion.*.network_interface.0.nat_ip_address
}
output "external_ip_address_gitlab" {
  value = yandex_compute_instance.gitlab.*.network_interface.0.nat_ip_address
}
