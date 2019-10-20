variable "chrome_host" {}
variable "chrome_port" {}
variable "network_name" {}

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
    name = "${var.network_name}"
    aliases = ["chrome"]
  }
}
