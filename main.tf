terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  token     = "y0_AgAAAABj4Os4AATuwQAAAADOo6CYJaxPUn8dR4yUWQ8F85PKIpHkjRo"
  cloud_id  = "b1gg6tea6kmo6vtakh5e"
  folder_id = "b1gvsquk6jvkrc1a16m3"
  zone      = "ru-central1-b"
}



resource "yandex_kubernetes_cluster" "study-cluster" {
 name        = "study-cluster"
 description = "study-cluster for project"
 network_id  = yandex_vpc_network.study.id


 master {
   zonal {
     zone      = yandex_vpc_subnet.study-subnet.zone
     subnet_id = yandex_vpc_subnet.study-subnet.id
   }

   public_ip = true
   maintenance_policy {
     auto_upgrade = false
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


# yandex_kubernetes_node_group

resource "yandex_kubernetes_node_group" "k8s_node_group" {
  cluster_id  = yandex_kubernetes_cluster.study-cluster.id
  name        = "worker"
  description = "worker node"
  version     = "1.21"

  labels = {
    "node_role" = "worker"
  }

  instance_template {
    platform_id = "standard-v3"

    network_interface {
      nat        = true
      subnet_ids = [yandex_vpc_subnet.study-subnet.id]
    }

    resources {
      memory        = 5
      cores         = 2
      core_fraction = 20

    }

    boot_disk {
      type = "network-hdd"
      size = 64
    }

    scheduling_policy {
      preemptible = false
    }

    container_runtime {
      type = "docker"
    }
  }
  
  scale_policy {
    fixed_scale {
      size = 1
    }
  }

  allocation_policy {
    location {
      zone = "ru-central1-b"
    }
  }
  

  maintenance_policy {
    auto_upgrade = false
    auto_repair  = false
  }
    
}