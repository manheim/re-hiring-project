#!/bin/bash

# Variables
S3_BUCKET_NAME="interview-s3-state-bucket"
DYNAMODB_TABLE_NAME="interview-dynamo-lock-table"
AWS_REGION="us-east-1"

# Check and delete S3 bucket contents
delete_s3_bucket_contents() {
    if aws s3api head-bucket --bucket "${S3_BUCKET_NAME}" --region ${AWS_REGION} 2>/dev/null; then
        echo "Deleting all contents in the S3 bucket: ${S3_BUCKET_NAME}"
        aws s3 rm "s3://${S3_BUCKET_NAME}" --recursive --region ${AWS_REGION}
    else
        echo "S3 bucket ${S3_BUCKET_NAME} does not exist or is already empty."
    fi
}

# Check and delete S3 bucket
delete_s3_bucket() {
    if aws s3api head-bucket --bucket "${S3_BUCKET_NAME}" --region ${AWS_REGION} 2>/dev/null; then
        echo "Deleting the S3 bucket: ${S3_BUCKET_NAME}"
        aws s3 rb "s3://${S3_BUCKET_NAME}" --force --region ${AWS_REGION}
    else
        echo "S3 bucket ${S3_BUCKET_NAME} does not exist."
    fi
}

# Check and delete DynamoDB table
delete_dynamodb_table() {
    if aws dynamodb describe-table --table-name ${DYNAMODB_TABLE_NAME} --region ${AWS_REGION} 2>/dev/null; then
        echo "Deleting the DynamoDB table: ${DYNAMODB_TABLE_NAME}"
        aws dynamodb delete-table --table-name ${DYNAMODB_TABLE_NAME} --region ${AWS_REGION}
    else
        echo "DynamoDB table ${DYNAMODB_TABLE_NAME} does not exist."
    fi
}

# Confirm before proceeding
read -p "Are you sure you want to delete all resources (S3 bucket and DynamoDB table)? This cannot be undone. Type 'yes' to continue: " CONFIRM
if [ "$CONFIRM" != "yes" ]; then
    echo "Operation cancelled."
    exit 0
fi

# Delete the Terraform backend configuration and any local state files if they exist
echo "Deleting Terraform backend configuration and local state files if they exist..."
rm -f ../terraform/backend/backend.tf 
# TODO: Add the rest of the destroy as progress on project continues
# rm -rf ../terraform

# Call the functions to check and delete AWS resources
delete_s3_bucket_contents
delete_s3_bucket
delete_dynamodb_table

echo "All specified resources and configurations have been checked and deleted if they existed."
