#!/bin/bash
echo "Creating S3 bucket for local development..."
awslocal s3 mb s3://tocopedia-images-dev
awslocal s3api put-bucket-policy --bucket tocopedia-images-dev --policy '{
  "Version":"2012-10-17",
  "Statement":[{
    "Effect":"Allow",
    "Principal":"*",
    "Action":"s3:GetObject",
    "Resource":"arn:aws:s3:::tocopedia-images-dev/*"
  }]
}'
echo "S3 bucket created successfully"
