terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  token     = "y0_AgAAAABj4Os4AATuwQAAAADMrYuJNEvE2sRdSTaz4nTskPa5cQJMjgk"
  cloud_id  = "b1gg6tea6kmo6vtakh5e"
  folder_id = "b1gvsquk6jvkrc1a16m3"
  zone      = "ru-central1-b"
}