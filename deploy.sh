      - name: Deploy to EC2
        env:
          AWS_REGION: ${{ secrets.AWS_REGION }}
          ECR_URI: ${{ env.ECR_URI }}
        run: |
          # Set target EC2 based on branch
          if [[ "${GITHUB_REF##*/}" == "main" ]]; then
            TARGET_USER=${{ secrets.EC2_USER_PROD }}
            TARGET_HOST=${{ secrets.EC2_HOST_PROD }}
          else
            TARGET_USER=${{ secrets.EC2_USER_STAGING }}
            TARGET_HOST=${{ secrets.EC2_HOST_STAGING }}
          fi

          mkdir -p ~/.ssh
          echo "${{ secrets.SSH_PRIVATE_KEY }}" > ~/.ssh/id_rsa
          chmod 600 ~/.ssh/id_rsa
          ssh-keyscan -H "$TARGET_HOST" >> ~/.ssh/known_hosts

          # Upload deployment files
          scp -i ~/.ssh/id_rsa docker-compose.prod.yml deploy.sh $TARGET_USER@$TARGET_HOST:/home/$TARGET_USER/
          scp -r -i ~/.ssh/id_rsa frontend backend $TARGET_USER@$TARGET_HOST:/home/$TARGET_USER/

          # Run deploy.sh remotely
          ssh -i ~/.ssh/id_rsa $TARGET_USER@$TARGET_HOST << EOF
            chmod +x /home/$TARGET_USER/deploy.sh
            aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_URI
            ./deploy.sh
          
          EOF
