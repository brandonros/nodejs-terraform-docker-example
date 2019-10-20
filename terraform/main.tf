provider "docker" {}

# volumes
variable "volumes_path" {}
# postgres
variable "postgres_host" {}
variable "postgres_user" {}
variable "postgres_password" {}
variable "postgres_database" {}
variable "postgres_port" {}
# redis
variable "redis_host" {}
variable "redis_port" {}
# chrome
variable "chrome_host" {}
variable "chrome_port" {}
# app
variable "app_port" {}
variable "app_version" {}
# nginx
variable "nginx_host" {}
variable "nginx_port" {}

# network
resource "docker_network" "private_network" {
  name = "my_network"
}

# postgres
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
    internal = "5432"
    external = "${var.postgres_port}"
  }

  networks_advanced {
    name = "${docker_network.private_network.name}"
    aliases = ["db"]
  }
}

# redis
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
    internal = "6379"
    external = "${var.redis_port}"
  }

  networks_advanced {
    name = "${docker_network.private_network.name}"
    aliases = ["redis"]
  }
}

# chrome
resource "docker_container" "chrome" {
  name  = "chrome"
  hostname = "chrome"
  image = "browserless/chrome:latest"
  restart = "always"

  env = [
    "HOST=${var.chrome_host}",
    "PORT=${var.chrome_port}",
  ]

  ports {
    internal = "${var.chrome_port}"
    external = "${var.chrome_port}"
  }

  networks_advanced {
    name = "${docker_network.private_network.name}"
    aliases = ["chrome"]
  }
}

# app
resource "docker_container" "app" {
  count = 2

  name  = "app-${count.index}"
  hostname = "app-${count.index}"
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
    "PORT=${parseint("${var.app_port}", 10) + count.index}",
    "BROWSER_ENDPOINT=ws://${var.chrome_host}:${var.chrome_port}",
  ]

  ports {
    internal = parseint("${var.app_port}", 10) + count.index
    external = parseint("${var.app_port}", 10) + count.index
  }

  networks_advanced {
    name = "${docker_network.private_network.name}"
    aliases = ["app-${count.index}"]
  }

  depends_on = [
    docker_container.db,
    docker_container.redis,
    docker_container.chrome
  ]
}

#nginx
resource "docker_container" "nginx" {
  name  = "nginx"
  hostname = "${var.nginx_host}"
  image = "nginx:alpine"
  restart = "always"

  env = [
    "NGINX_PORT=${var.nginx_port}",
  ]

  volumes {
    host_path = abspath("../nginx/nginx.conf")
    container_path = "/etc/nginx/nginx.conf"
  }

  volumes {
    host_path = abspath("../nginx/html")
    container_path = "/usr/share/nginx/html"
  }

  ports {
    internal = "${var.nginx_port}"
    external = "${var.nginx_port}"
  }

  networks_advanced {
    name = "${docker_network.private_network.name}"
    aliases = ["nginx"]
  }

  depends_on = [
    docker_container.app,
  ]
}