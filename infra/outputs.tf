output "ec2_ip" {
  value = module.ec2_instance.private_ip[0]
}

output "db_username"{
  value = var.master_username
}

output "db_password"{
  value = var.master_password
}

output "db_ip" {
  value = module.documentdb_cluster.endpoint
}