#!/bin/bash

set -env

TAG=$1

if [ -z "$TAG" ]; then
  echo "Usage: ./deploy.sh <tag>"
  exit 1
fi

echo "Starting deployment for tag: $TAG"

# Set ECR repo prefix (replace with your actual repo URL or pass it as env var)
ECR_URI="600748199143.dkr.ecr.us-east-1.amazonaws.com/tasktracker-backend"
ECR_URI="600748199143.dkr.ecr.us-east-1.amazonaws.com/tasktracker-frontend"


echo "Logging into ECR..."
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $ECR_URI

echo "Pulling backend image with tag $TAG..."
docker pull $ECR_URI/tasktracker-backend:$TAG

echo "Pulling frontend image with tag $TAG..."
docker pull $ECR_URI/tasktracker-frontend:$TAG

echo "Stopping and removing old containers..."
docker-compose down

echo "Starting containers with docker-compose..."
docker-compose up -d

echo "Deployment completed for tag: $TAG"

EOF

chmod +x deploy.sh