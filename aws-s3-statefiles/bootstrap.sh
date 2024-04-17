#!/usr/bin/env bash
set -e

if [ -z "$AWS_ACCOUNT" ]; then
  echo "AWS_ACCOUNT is not set. Exiting."
  exit 1
fi

bucket_name="terraform-statefiles-$AWS_ACCOUNT"
export TF_VAR_aws_account=$AWS_ACCOUNT

if ! terraform --version > /dev/null 2>&1; then
  echo "Terraform is not installed. Exiting."
  exit 1
fi

if ! aws --version > /dev/null 2>&1; then
  echo "AWS CLI is not installed. Exiting."
  exit 1
fi

if ! aws s3 ls > /dev/null 2>&1; then
  echo "AWS CLI is not configured. Exiting."
  exit 1
fi

if aws s3 ls | grep -q "$bucket_name"; then
  echo "Bucket '$bucket_name' already exists, skipping creation..."
else
    echo "Creating s3 bucket '$bucket_name'..."
    aws s3api create-bucket --bucket "$bucket_name"
fi

echo "Running 'terraform init'..."
terraform init --backend-config "bucket=$bucket_name"

if ! terraform state list > /dev/null 2>&1; then
    echo "Importing s3 bucket to Terraform..."
    terraform import aws_s3_bucket.statefiles "$bucket_name"
else
    echo "Bucket already configured as Terraform statefile store, skipping import..."
fi

echo "Applying bucket policies to s3 bucket..."
terraform apply -auto-approve
