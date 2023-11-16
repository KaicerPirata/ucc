terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {}


resource "docker_image" "nodejs_image" {
    name = "williamaguilera/mecadato_2:latest"

}

resource "docker_container" "nodeapi" {
  image = docker_image.nodejs_image.image_id
  name  = "node_api"
  ports {
    internal = 8080
    external = 3000
  }

}

resource "docker_image" "python" {
    name = "williamaguilera/imagephyton:latest"

}

resource "docker_image" "postgres" {
    name = "williamaguiler/posgres"

}

resource "docker_container" "postgresql" {
  image = docker_image.postgres.image_id
  name  = "postgresql"
  ports {
      internal = 9876
      external = 9876
    }

  env = ["POSTGRES_USER=postgres", 
    "POSTGRES_PASSWORD=123456"]

     
}


resource "docker_image" "image_firewall" {
  name = "api-firewall:latest"
}

resource "docker_container" "firewall" {
  name  = "firewall"
  image = docker_image.image_firewall.image_id
  
  restart = "on-failure"

  env = [
    "APIFW_URL=http://0.0.0.0:8080",
    "APIFW_API_SPECS=/opt/resources/httpbin.json",
    "APIFW_SERVER_URL=http://backend:80",
    "APIFW_SERVER_MAX_CONNS_PER_HOST=512",
    "APIFW_SERVER_READ_TIMEOUT=5s",
    "APIFW_SERVER_WRITE_TIMEOUT=5s",
    "APIFW_SERVER_DIAL_TIMEOUT=200ms",
    "APIFW_REQUEST_VALIDATION=BLOCK",
    "APIFW_RESPONSE_VALIDATION=BLOCK",
    "APIFW_DENYLIST_TOKENS_FILE=/opt/resources/tokens.denylist.db",
    "APIFW_DENYLIST_TOKENS_COOKIE_NAME=test",
    "APIFW_DENYLIST_TOKENS_HEADER_NAME=",
    "APIFW_DENYLIST_TOKENS_TRIM_BEARER_PREFIX=true"
  ]

  ports {
    internal = 8080
    external = 8080
  }

  volumes {
    container_path  = "/opt/resources"
    host_path      = "/volumes/api-firewall"
    read_only      = true
  }

  
}
