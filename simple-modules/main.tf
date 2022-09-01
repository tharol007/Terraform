provider "aws" {
	region = "ap-south-1"
}

module "aws-ec2" {
  source = "./modules/ec2"
}

module "aws-s3" {
  source = "./modules/s3"
}
