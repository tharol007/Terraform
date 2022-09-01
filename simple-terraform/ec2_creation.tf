
provider "aws" {
	region = "ap-south-1"
  profile = "default"
}

terraform {
  backend "s3" {
    bucket = "terraform-backend-spovedd11"
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }
}

resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true

  
}

resource "aws_subnet" "public-subnet" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1a"

}

resource "aws_security_group" "sgweb" {
  name = "vpc_test_web"
  description = "Allow incoming HTTP connections & SSH access"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks =  ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  vpc_id="${aws_vpc.default.id}"

}

resource "aws_instance" "web" {
	ami = "ami-06489866022e12a14"
	instance_type = "t2.micro"
	subnet_id = "${aws_subnet.public-subnet.id}"
	vpc_security_group_ids = ["${aws_security_group.sgweb.id}"]

  tags = {
    Name = "aws-s3-trial"
  }
}

resource "aws_s3_bucket" "b" {
  bucket = "my-tf-test-bucket-fhgfgg1"
  //acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_acl" "b_acl" {
  bucket = aws_s3_bucket.b.id
  acl    = "private"
}
