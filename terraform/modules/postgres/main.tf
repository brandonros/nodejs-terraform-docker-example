variable "volumes_path" {}
variable "postgres_host" {}
variable "postgres_user" {}
variable "postgres_password" {}
variable "postgres_database" {}
variable "postgres_port" {}
variable "network_name" {}

resource "docker_container" "db" {
  name  = "db"
  hostname = "${var.postgres_host}"
  image = "postgres:alpine"
  restart = "always"

  env = [
    "POSTGRES_USER=${var.postgres_user}",
    "POSTGRES_PASSWORD=${var.postgres_password}",
    "POSTGRES_DB=${var.postgres_database}"
  ]

  volumes {
    host_path = abspath("${var.volumes_path}/postgres")
    container_path = "/var/lib/postgresql/data"
  }

  ports {
    internal = "${var.postgres_port}"
    external = "${var.postgres_port}"
  }

  networks_advanced {
    name = "${var.network_name}"
    aliases = ["db"]
  }
}
