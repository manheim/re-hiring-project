#!/bin/bash

set -e

ENVIRONMENT=$1

if [ -z "$ENVIRONMENT" ]; then
  echo "Usage: $0 <environment>"
  exit 1
fi

cd terraform
terraform destroy -var "environment=${ENVIRONMENT}" -auto-approve
