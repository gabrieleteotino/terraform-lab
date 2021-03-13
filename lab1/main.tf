terraform {
  required_providers {
    docker = {
        source = "kreuzwerker/docker"
        version = "2.8.0"
    }
  }
}

provider "docker" {
    # This is required for connection to docker for windows
    host    = "npipe:////.//pipe//docker_engine"
}

resource "docker_image" "container_image" {
  name = "grafana/grafana"
}