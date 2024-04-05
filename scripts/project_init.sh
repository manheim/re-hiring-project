#!/bin/bash

# Check if AWS CLI is configured
if ! aws sts get-caller-identity > /dev/null 2>&1; then
    echo "AWS CLI is not configured. Please enter your AWS credentials."
    aws configure
else
    echo "AWS CLI is already configured."
fi

# Variables
S3_BUCKET_NAME="interview-s3-state-bucket"
DYNAMODB_TABLE_NAME="interview-dynamo-lock-table"
AWS_REGION="us-east-1"

# Check if the S3 bucket exists and create if necessary
if aws s3 ls | grep -q "${S3_BUCKET_NAME}"; then
    echo "S3 bucket already exists: ${S3_BUCKET_NAME}"
else
    echo "Creating S3 bucket for Terraform state: ${S3_BUCKET_NAME}"
    aws s3 mb s3://${S3_BUCKET_NAME} --region ${AWS_REGION}
    aws s3api put-bucket-versioning --bucket ${S3_BUCKET_NAME} --versioning-configuration Status=Enabled --region ${AWS_REGION}
fi

# Check if the DynamoDB table exists and create if necessary
if aws dynamodb describe-table --table-name "${DYNAMODB_TABLE_NAME}" --region "${AWS_REGION}" >/dev/null 2>&1; then
    echo "DynamoDB table for Terraform state locking already exists: ${DYNAMODB_TABLE_NAME}"
else
    echo "Creating DynamoDB table for Terraform state locking: ${DYNAMODB_TABLE_NAME}"
    aws dynamodb create-table \
    --table-name "${DYNAMODB_TABLE_NAME}" \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST \
    --region "${AWS_REGION}"
fi

# Generate backend.tf file for Terraform if it doesn't already exist
echo "Checking if backend.tf file exists..."
if [ ! -f ../terraform/backend/backend.tf ]; then
    echo "backend.tf file does not exist. Generating backend.tf file for Terraform..."
    cat <<EOF > ../terraform/backend/backend.tf
terraform {
  backend "s3" {
    bucket         = "${S3_BUCKET_NAME}"
    key            = "state/terraform.tfstate"
    region         = "${AWS_REGION}"
    dynamodb_table = "${DYNAMODB_TABLE_NAME}"
    encrypt        = true
  }
}
EOF
else
    echo "backend.tf file already exists."
fi

echo "Checking if Terraform has been initialized..."
if [ -d ".terraform" ] && [ "$(ls -A .terraform)" ]; then
    echo "Terraform has already been initialized."
else
    echo "Running 'terraform init' to initialize the Terraform environment with remote state management"
    cd ../terraform/backend/ && terraform init
    echo "Terraform has been initialized with remote state management."
fi
