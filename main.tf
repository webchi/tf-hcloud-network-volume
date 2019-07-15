provider "hcloud" {
  token = var.hcloud_token
}

data "hcloud_ssh_key" "myssh" {
  name = var.ssh_name
}

resource "hcloud_network" "mynetwork" {
  name = "mynetwork"
  ip_range = "10.0.0.0/8"
}

resource "hcloud_network_subnet" "main" {
  network_id = hcloud_network.mynetwork.id
  type = "server"
  network_zone = "eu-central"
  ip_range   = "10.0.1.0/24"
}

resource "hcloud_server_network" "mynetwork" {
  count       = var.node_count
  server_id   = element(hcloud_server.mynode.*.id, count.index)
  network_id  = hcloud_network.mynetwork.id
}


resource "hcloud_volume" "volume" {
  count       = var.node_count
  location    = "nbg1"
  name        = "vol-${count.index}"
  size        = "10"
  format      = "ext4"
}

resource "hcloud_volume_attachment" "main" {
  count     = var.node_count
  volume_id = "${hcloud_volume.volume[count.index].id}"
  server_id = "${hcloud_server.mynode[count.index].id}"
}

resource "hcloud_server" "mynode" {
  count       = var.node_count
  name        = "node-${count.index}"
  image       = "ubuntu-18.04"
  server_type = "cx11"
  location    = "nbg1"
  ssh_keys    = [data.hcloud_ssh_key.myssh.id]
}



