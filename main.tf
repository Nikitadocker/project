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



resource "yandex_kubernetes_cluster" "study-cluster" {
 network_id = yandex_vpc_network.study.id
 master {
   zonal {
     zone      = yandex_vpc_subnet.study-subnet.zone
     subnet_id = yandex_vpc_subnet.study-subnet.id
   }
 }
 service_account_id      = yandex_iam_service_account.study-sa.id
 node_service_account_id = yandex_iam_service_account.study-sa.id
   depends_on = [
     yandex_resourcemanager_folder_iam_binding.editor,
     yandex_resourcemanager_folder_iam_binding.images-puller
   ]
}

resource "yandex_vpc_network" "study" { name = "study" }

resource "yandex_vpc_subnet" "study-subnet" {
 v4_cidr_blocks = ["10.5.0.0/24"]
 zone           = "ru-central1-b"
 network_id     = yandex_vpc_network.study.id
}

resource "yandex_iam_service_account" "study-sa" {
 name        = "study-sa"
 description = "service account for cluster"
}

resource "yandex_resourcemanager_folder_iam_binding" "editor" {
 # Сервисному аккаунту назначается роль "editor".
 folder_id = "b1gvsquk6jvkrc1a16m3"
 role      = "editor"
 members   = [
   "serviceAccount:${yandex_iam_service_account.study-sa.id}"
 ]
}

resource "yandex_resourcemanager_folder_iam_binding" "images-puller" {
 # Сервисному аккаунту назначается роль "container-registry.images.puller".
 folder_id = "b1gvsquk6jvkrc1a16m3"
 role      = "container-registry.images.puller"
 members   = [
   "serviceAccount:${yandex_iam_service_account.study-sa.id}"
 ]
}
