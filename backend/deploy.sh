#!/bin/bash

cd /home/ubuntu

echo "[INFO] Stopping previous containers..."
docker-compose -f docker-compose.prod.yml down

echo "[INFO] Pulling latest code and rebuilding..."
docker-compose -f docker-compose.prod.yml up -d --build
