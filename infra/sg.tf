module "websg" {
  source = "terraform-aws-modules/security-group/aws"
  name = "web-service"
  description = "Security group for HTTP and SSH within VPC"
  vpc_id = module.vpc.vpc_id
  ingress_rules = ["http-80-tcp", "https-443-tcp", "ssh-tcp", "all-icmp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_ipv6_cidr_blocks = []
  egress_rules = ["all-all"]
  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_ipv6_cidr_blocks = []
}
module "appsg" {
  source = "terraform-aws-modules/security-group/aws"
  name = "app-service"
  description = "Security group for App within VPC"
  vpc_id = module.vpc.vpc_id
  ingress_ipv6_cidr_blocks = []
  egress_ipv6_cidr_blocks = []
  ingress_with_source_security_group_id = [
    {
      rule = "all-all"
      source_security_group_id = "${module.websg.security_group_id}"
    },
  ]
  
  egress_with_source_security_group_id = [
    {
      rule = "all-all"
      source_security_group_id = "${module.websg.security_group_id}"
    },
  ]
}

module "dbssg" {
  source = "terraform-aws-modules/security-group/aws"
  name = "dbs-service"
  description = "Security group for Database within VPC"
  vpc_id = module.vpc.vpc_id
  ingress_ipv6_cidr_blocks = ["10.0.0.0/16"]
  egress_ipv6_cidr_blocks = []
  ingress_with_source_security_group_id = [
    {
      rule = "all-all"
      source_security_group_id = "${module.appsg.security_group_id}"
    },
  ]
  egress_with_source_security_group_id = [
    {
      rule = "all-all"
      source_security_group_id = "${module.appsg.security_group_id}"
    },
  ]
  ingress_with_cidr_blocks = [
    {
      from_port   = 27017
      to_port     = 27017
      protocol    = 6
      description = "DocDB"
      cidr_blocks = "10.0.0.0/16"
    },
  ]
}