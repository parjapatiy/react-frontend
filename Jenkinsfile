pipeline {
    agent any
    environment {
        AWS_ACCOUNT_ID="421320058418"
        AWS_DEFAULT_REGION="ap-south-1" 
        IMAGE_REPO_NAME="yanshul-frontend"
        IMAGE_TAG="v6"
        REPOSITORY_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}"
    }
   
    stages {
        
         stage('Logging into AWS ECR') {
            steps {
                script {
                sh "aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"
                }
                 
            }
        }
        
        
  
    // Building Docker images
    stage('Building image') {
      steps{
        script {
          dockerImage = docker.build "${IMAGE_REPO_NAME}:${IMAGE_TAG}"
        }
      }
    }
   
    // Uploading Docker images into AWS ECR
    stage('Pushing to ECR') {
     steps{  
         script {
                sh "docker tag ${IMAGE_REPO_NAME}:${IMAGE_TAG} ${REPOSITORY_URI}:$IMAGE_TAG"
                sh "docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}:${IMAGE_TAG}"
         }
        }
      }
      
     stage('Deploy in ECS') {
            steps {
                        sh("/usr/local/bin/aws ecs register-task-definition --region ap-south-1 --family yanshul-frontend --execution-role-arn arn:aws:iam::421320058418:role/ecsTaskExecutionRole --requires-compatibilities EC2 --network-mode bridge --cpu 250 --memory 250 --container-definitions file://./ecs/defination.json")
                        sh("/usr/local/bin/aws ecs update-service --cluster yanshul --service frontend --task-definition yanshul-frontend:17")
                    }
                }
            }
     }
      
    
    

