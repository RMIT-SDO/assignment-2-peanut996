resource "aws_docdb_cluster_parameter_group" "tlsdisable" {
  family      = "docdb4.0"
  name        = "tls-disable"
  description = "docdb cluster parameter group dissable tls"

  parameter {
    apply_method = "pending-reboot"
    name         = "tls"
    value        = "disabled"
  }
}

module "documentdb_cluster" {
  source          = "cloudposse/documentdb-cluster/aws"
  name            = "my-docdb"
  cluster_size    = 1
  master_username = var.master_username
  master_password = var.master_password
  instance_class  = "db.r4.large"
  db_port         = 27017
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.database_subnets
  zone_id         = "us-east-1a"

  allowed_security_groups = [module.dbssg.security_group_id]
  cluster_parameters = [{
    apply_method = "pending-reboot"
    name         = "tls"
    value        = "disabled"
  }]
}
