provider "aws" {
  region = "us-east-1"
}

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "statefiles" {
  bucket        = "terraform-statefiles-${data.aws_caller_identity.current.account_id}"
  force_destroy = false # go manually empty the bucket by `terraform destroy`ing all other projects in the bucket
}

resource "aws_s3_bucket_versioning" "statefiles" {
  bucket = aws_s3_bucket.statefiles.bucket
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "statefiles" {
  bucket                  = aws_s3_bucket.statefiles.bucket
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}
