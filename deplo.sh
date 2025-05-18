#!/bin/bash

ENV=$1
APP=$2

if [[ -z "$ENV" || -z "$APP" ]]; then
  echo "Usage: ./deploy.sh <staging|prod> <frontend|backend>"
  exit 1
fi

APP_DIR="/var/www/${APP}-${ENV}"

echo "Deploying $APP to $ENV environment..."

# Ensure directory exists
ssh ec2-user@${HOST} "mkdir -p $APP_DIR"

# Sync files
rsync -avz -e "ssh -i ~/.ssh/${KEY}" ./${APP}/ ec2-user@${HOST}:$APP_DIR

# Restart services (optional, if using systemd or PM2)
ssh ec2-user@${HOST} << EOF
  cd $APP_DIR
  echo "Running deployment steps for $APP in $ENV..."
  # Example: npm install && pm2 restart app
  if [ -f package.json ]; then
    npm install
    pm2 restart ${APP}-${ENV} || pm2 start index.js --name ${APP}-${ENV}
  fi
EOF

echo "✅ Deployment complete for $APP to $ENV"
