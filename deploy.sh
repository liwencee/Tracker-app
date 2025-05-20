#!/bin/bash

set -e

if [ -z "$ECR_URI" ]; then
  echo "ECR_URI is not set"
  exit 1
fi

BRANCH=$(basename $(git symbolic-ref HEAD 2>/dev/null || echo "refs/heads/main"))
export BRANCH=$BRANCH

echo "Deploying branch: $BRANCH"
echo "Pulling images from: $ECR_URI"

docker pull $ECR_URI/tasktracker-frontend:$BRANCH
docker pull $ECR_URI/tasktracker-backend:$BRANCH

# Optional: Clean up unused Docker resources
# docker system prune -af

docker-compose -f docker-compose.prod.yml down
docker-compose -f docker-compose.prod.yml up -d