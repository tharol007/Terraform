resource "aws_s3_bucket" "b" {
  bucket = "my-tf-test-bucket-ggff"
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

