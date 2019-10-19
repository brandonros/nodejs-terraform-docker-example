variable "volumes_path" {}
variable "redis_host" {}
variable "redis_port" {}
variable "network_name" {}

resource "docker_container" "redis" {
  name  = "redis"
  hostname = "${var.redis_host}"
  image = "redis:alpine"
  command = ["redis-server", "--appendonly", "yes"]
  restart = "always"

  volumes {
    host_path = abspath("${var.volumes_path}/redis")
    container_path = "/data"
  }

  ports {
    internal = "${var.redis_port}"
    external = "${var.redis_port}"
  }

  networks_advanced {
    name = "${var.network_name}"
    aliases = ["redis"]
  }
}
