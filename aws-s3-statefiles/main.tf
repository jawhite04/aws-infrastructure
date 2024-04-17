module "aws_statefile_bucket" {
  source = "./modules/s3-bucket"
  providers = {
    aws.target = aws.source
  }
  aws_account = var.aws_account
}
