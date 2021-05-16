resource "aws_key_pair" "deployer" {
  key_name   = "my-key-pair"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDRmSXkzu+Etp9MBL9InoZRCQyVW+Ey0atOgyznjlx6he4q+ZhNuv4xr2DI+57dC8XkLUnTabHh/tEEEy8oeuoSGNedU/jWS4dmUFjG3pUKme/tIld+yM7i0PdyHytCClQ4bio3J+RSgu8cffMpQNkRuqZEGtZOrxXeCfKydFtPl9VNOy8p8HwAmN5Dc38FdHced2dBQNn8XiQggwoQp9bq1DZKEHmaW33P5iOnehNaVg/qt0tFlIr1rc3jwjI4FBXTWdGZkOkghfCVbGy2k1YjnUkEFLL6hB+JFj9JNPIUG8K4eu5UEzWspvKzi1B7YClVJM75VqM0DWpRkbfQJza9 peanut996"
}
module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 2.0"

  name           = "my-ec2-instance"
  instance_count = 1

  ami                    = data.aws_ami.latest-ubuntu.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.deployer.key_name
  monitoring             = true
  vpc_security_group_ids = [module.websg.security_group_id]
  subnet_id              = module.vpc.private_subnets[0]


  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

data "aws_ami" "latest-ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
