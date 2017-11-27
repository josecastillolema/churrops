output "ip" {
  value = "${openstack_compute_floatingip_v2.floatip.address}"
}
