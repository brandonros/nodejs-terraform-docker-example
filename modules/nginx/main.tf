variable "volumes_path" {}
variable "nginx_host" {}
variable "nginx_port" {}
variable "network_name" {}

resource "docker_container" "nginx" {
  name  = "nginx"
  hostname = "${var.nginx_host}"
  image = "nginx:alpine"
  restart = "always"

  env = [
    "NGINX_PORT=${var.nginx_port}",
  ]

  volumes {
    host_path = abspath("./nginx.conf")
    container_path = "/etc/nginx/nginx.conf"
  }

  volumes {
    host_path = abspath("./html")
    container_path = "/usr/share/nginx/html"
  }

  ports {
    internal = "${var.nginx_port}"
    external = "${var.nginx_port}"
  }

  networks_advanced {
    name = "${var.network_name}"
    aliases = ["nginx"]
  }
}
