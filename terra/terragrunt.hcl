terraform {
  source = "./terraform"
}

inputs = {
  aws_region        = "eu-central-1"
  availability_zone = "eu-central-1a"
  ami_id            = "ami-0e54671bdf3c8ed8d"
  instance_type     = "t2.xlarge"
  my_ip             = "93.202.227.251/32"
  amount_of_brokers = "3"
}
