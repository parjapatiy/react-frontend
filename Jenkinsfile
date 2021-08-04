#!/usr/bin/env groovy

pipeline {
    agent any
    environment {
        AWS_ACCOUNT_ID=credentials('AWS_ACCOUNT_ID')
        AWS_DEFAULT_REGION="ap-south-1" 
        IMAGE_REPO_NAME=credentials('IMAGE_REPO_NAME')
        REPOSITORY_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}"
        BACKENDURL=credentials('BACKENDURL')
        AWS_ECR_REGION = 'ap-south-1'
        AWS_ECS_SERVICE = credentials('AWS_ECS_SERVICE')
        AWS_ECS_TASK_DEFINITION = credentials('AWS_ECS_TASK_DEFINITION')
        AWS_ECS_COMPATIBILITY = 'EC2'
        AWS_ECS_NETWORK_MODE = 'bridge'
        AWS_ECS_CPU = '250'
        AWS_ECS_MEMORY = '260'
        AWS_ECS_CLUSTER = credentials('AWS_ECS_CLUSTER')
        AWS_ECS_TASK_DEFINITION_PATH = './ecs/defination.json'
        AWS_ECS_EXECUTION_ROLE = credentials('AWS_ECS_EXECUTION_ROLE')
        
    }
   
    stages {
        
         stage('Logging into AWS ECR') {
            steps {
                script {
                
                sh "aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"
                }
                 
            }
        }
        
    stage('Cloning Git') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: '', url: 'https://github.com/parjapatiy/react-frontend.git/']]])     
            }
        }
        
        
  
    // Building Docker images
    stage('Building image') {
      steps{
        script {
          
          
          sh "docker build -t ${IMAGE_REPO_NAME}:${env.BUILD_ID} --build-arg backend=${BACKENDURL} ."
        }
      }
    }
   
    // Uploading Docker images into AWS ECR
    stage('Pushing to ECR') {
     steps{  
         script {
                sh "docker tag ${IMAGE_REPO_NAME}:${env.BUILD_ID} ${REPOSITORY_URI}:${env.BUILD_ID}"
                sh "docker push ${REPOSITORY_URI}:${env.BUILD_ID}"
         }
        }
      }
      
     stage('Deploy in ECS') {
            steps {
                script {
                        updateContainerDefinitionWithImageVersion()
                        sh("aws ecs register-task-definition --region ${AWS_ECR_REGION} --family ${AWS_ECS_TASK_DEFINITION} --execution-role-arn ${AWS_ECS_EXECUTION_ROLE} --requires-compatibilities ${AWS_ECS_COMPATIBILITY} --network-mode ${AWS_ECS_NETWORK_MODE} --cpu ${AWS_ECS_CPU} --memory ${AWS_ECS_MEMORY} --container-definitions file://${AWS_ECS_TASK_DEFINITION_PATH}")
                        def taskrevision = sh(script: "/usr/local/bin/aws ecs describe-task-definition --task-definition ${AWS_ECS_TASK_DEFINITION} | egrep \"revision\"  | awk '{print \$2}'  | sed 's/,/ /'", returnStdout: true)
                        sh("aws ecs update-service --cluster ${AWS_ECS_CLUSTER} --service ${AWS_ECS_SERVICE} --task-definition ${AWS_ECS_TASK_DEFINITION}:${taskrevision}")
                    } 
                    }
                }
  
}
}

def updateContainerDefinitionWithImageVersion() {
    def containerDefinitionJson = readJSON file: AWS_ECS_TASK_DEFINITION_PATH, returnPojo: true
    containerDefinitionJson[0]['image'] = "${REPOSITORY_URI}:${env.BUILD_ID}".inspect()
    echo "task definiton json: ${containerDefinitionJson}"
    writeJSON file: AWS_ECS_TASK_DEFINITION_PATH, json: containerDefinitionJson
}
      
    
