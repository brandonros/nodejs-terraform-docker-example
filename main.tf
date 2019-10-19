provider "docker" {}

# declare any input variables
variable "volumes_path" {}
variable "postgres_host" {}
variable "postgres_user" {}
variable "postgres_password" {}
variable "postgres_port" {}
variable "postgres_database" {}
variable "redis_host" {}
variable "redis_port" {}
variable "app_version" {}
variable "app_port" {}

# create docker network resource
resource "docker_network" "private_network" {
  name = "my_network"
}

# create db container
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
    host_path = "${var.volumes_path}/postgres"
    container_path = "/var/lib/postgresql/data"
  }

  ports {
    internal = "${var.postgres_port}"
    external = "${var.postgres_port}"
  }

  networks_advanced {
    name = "${docker_network.private_network.name}"
    aliases = ["db"]
  }
}

# create redis container
resource "docker_container" "redis" {
  name  = "redis"
  hostname = "${var.redis_host}"
  image = "redis:alpine"
  command = ["redis-server", "--appendonly", "yes"]
  restart = "always"

  volumes {
    host_path = "${var.volumes_path}/redis"
    container_path = "/data"
  }

  ports {
    internal = "${var.redis_port}"
    external = "${var.redis_port}"
  }

  networks_advanced {
    name = "${docker_network.private_network.name}"
    aliases = ["redis"]
  }
}

# create app container
resource "docker_container" "app" {
  name  = "app"
  hostname = "app"
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
  ]

  ports {
    internal = "${var.app_port}"
    external = "${var.app_port}"
  }

  networks_advanced {
    name = "${docker_network.private_network.name}"
    aliases = ["app"]
  }
}
