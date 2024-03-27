terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
    null = {
      source = "hashicorp/null"
    }
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}
