terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.8.0"
    }
  }
}

provider "docker" {
  # This is required for connection to docker for windows
  host = "npipe:////.//pipe//docker_engine"
}

resource "docker_image" "container_image" {
  name = "grafana/grafana"
}

resource "docker_container" "container" {
  count = 2
  name  = "grafana_container-${count.index}"
  image = docker_image.container_image.latest
  ports {
    internal = var.int_port
    external = var.ext_port[count.index]
  }
  # user and working_dir are needed to work around some stupid bug that forces recreation
  user        = 472
  working_dir = "/usr/share/grafana"
}

output "public_ip" {
  value = [for x in docker_container.container : "${x.name} - ${x.ip_address}:${x.ports[0].external}"]
}
