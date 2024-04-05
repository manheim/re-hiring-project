#!/bin/bash

COMMENT_BODY=$(jq -r '.comment.body' "$GITHUB_EVENT_PATH")

if [[ "$COMMENT_BODY" == *"#terraform apply"* ]]; then
    terraform init
    terraform apply -auto-approve
fi
