variable "postgres_user" {}
variable "postgres_password" {}
variable "postgres_database" {}
variable "postgres_host" {}
variable "postgres_port" {}
variable "redis_host" {}
variable "redis_port" {}
variable "app_port" {}
variable "app_version" {}
variable "network_name" {}

resource "docker_container" "app-001" {
  name  = "app-001"
  hostname = "app-001"
  image = "app:${var.app_version}"
  restart = "always"

  env = [
    "POSTGRES_HOST=${var.postgres_host}",
    "POSTGRES_PORT=${var.postgres_port}",
    "POSTGRES_USER=${var.postgres_user}",
    "POSTGRES_PASSWORD=${var.postgres_password}",
    "POSTGRES_DB=${var.postgres_database}",
    "REDIS_HOST=${var.redis_host}",
    "REDIS_PORT=${var.redis_port}",
    "PORT=${var.app_port}",
    "BROWSER_ENDPOINT=ws://chrome:5000",
  ]

  ports {
    internal = "${var.app_port}"
    external = "${var.app_port}"
  }

  networks_advanced {
    name = "${var.network_name}"
    aliases = ["app-001"]
  }
}
