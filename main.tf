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
# app
variable "app_001_port" {}
variable "app_002_port" {}
variable "app_version" {}
# nginx
variable "nginx_host" {}
variable "nginx_port" {}

resource "docker_network" "private_network" {
  name = "my_network"
}

module "postgres" {
  source = "./modules/postgres"
  volumes_path = "${var.volumes_path}"
  postgres_host = "${var.postgres_host}"
  postgres_user = "${var.postgres_user}"
  postgres_password = "${var.postgres_password}"
  postgres_database = "${var.postgres_database}"
  postgres_port = "${var.postgres_port}"
  network_name = "${docker_network.private_network.name}"
}

module "redis" {
  source = "./modules/redis"
  volumes_path = "${var.volumes_path}"
  redis_host = "${var.redis_host}"
  redis_port = "${var.redis_port}"
  network_name = "${docker_network.private_network.name}"
}

module "app-001" {
  source = "./modules/app-001"
  postgres_host = "${var.postgres_host}"
  postgres_user = "${var.postgres_user}"
  postgres_password = "${var.postgres_password}"
  postgres_database = "${var.postgres_database}"
  postgres_port = "${var.postgres_port}"
  redis_host = "${var.redis_host}"
  redis_port = "${var.redis_port}"
  app_port = "${var.app_001_port}"
  app_version = "${var.app_version}"
  network_name = "${docker_network.private_network.name}"
}

module "app-002" {
  source = "./modules/app-002"
  postgres_host = "${var.postgres_host}"
  postgres_user = "${var.postgres_user}"
  postgres_password = "${var.postgres_password}"
  postgres_database = "${var.postgres_database}"
  postgres_port = "${var.postgres_port}"
  redis_host = "${var.redis_host}"
  redis_port = "${var.redis_port}"
  app_port = "${var.app_002_port}"
  app_version = "${var.app_version}"
  network_name = "${docker_network.private_network.name}"
}

module "nginx" {
  source = "./modules/nginx"
  volumes_path = "${var.volumes_path}"
  nginx_host = "${var.nginx_host}"
  nginx_port = "${var.nginx_port}"
  network_name = "${docker_network.private_network.name}"
}
