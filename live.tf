provider "openstack" {
    user_name   = "churroper"
    tenant_name = "devel"
    tenant_id   = "12345"
    password    = "senha"
    auth_url    = "https://keystone.openstack.com.br:5000/v2.0"
}

variable "defaults" {
    description = "OpenStack Variables for Tenant"
    type = "map"
    default  {
        image_name     = "linux-ubuntu-16-64b-base"
        az_name        = "nova"
        region         = "SP"
        tenant_name    = "churrops"
        key_pair       = "chave"
        flavor_name    = "g1.micro"
        security_group = "default"
        network_name   = "rede-interna"
    }
}

resource "openstack_compute_instance_v2" "web" {
  name = "web"
  image_name = "${var.defaults["image_name"]}"
  flavor_name = "${var.defaults["flavor_name"]}"
  availability_zone = "${var.defaults["az_name"]}"
  key_pair = "${var.defaults["key_pair"]}"
  security_groups = ["${var.defaults["security_group"]}"]
  network {
    name = "${var.defaults["network_name"]}"
  }
  user_data = "${file("bootstrapweb.sh")}"
  lifecycle {
    create_before_destroy = true
  }
}

resource "openstack_networking_floatingip_v2" "ip-publica" {
  pool = "rede-publica"
}

resource "openstack_compute_floatingip_associate_v2" "asoc-ip-publica" {
  floating_ip = "${openstack_networking_floatingip_v2.ip-publica.address}"
  instance_id = "${openstack_compute_instance_v2.web.id}"
}
