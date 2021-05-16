resource "aws_lb" "nlb_1" {
  name               = "network-lb-1"
  internal           = false
  load_balancer_type = "network"
  subnets            = module.vpc.public_subnets

  enable_deletion_protection = true

  tags = {
    Environment = "production"
  }
}