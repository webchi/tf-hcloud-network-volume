output "my-ips" {
  value = [hcloud_server.mynode.*.ipv4_address]
}
