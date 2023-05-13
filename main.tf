provider "aws" {
  region = "ap-south-1"
}

resource "aws_s3_bucket" "terraform_state_bucket" {
  bucket = "web-infra-tf-state-01"

  tags = {
    Name = "Terraform State Bucket"
    environment = "Production"
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "terraform_state_bucket_versioning" {
  bucket = aws_s3_bucket.terraform_state_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}