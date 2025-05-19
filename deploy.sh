#!/bin/bash

set -env

# Set environment
BRANCH=$(basename $(git symbolic-ref HEAD 2>/dev/null || echo "refs/heads/main"))
export BRANCH=$BRANCH

# Pull latest images
docker pull $ECR_URI/tasktracker-frontend:$BRANCH
docker pull $ECR_URI/tasktracker-backend:$BRANCH

# Deploy
docker-compose -f docker-compose.prod.yml down
docker-compose -f docker-compose.prod.yml up -d
