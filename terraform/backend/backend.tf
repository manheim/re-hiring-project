terraform {
  backend "s3" {
    bucket         = "interview-s3-state-bucket"
    region         = "us-east-1"
    dynamodb_table = "interview-dynamo-lock-table"
    encrypt        = true
  }
}
