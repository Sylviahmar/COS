pipeline {
    agent any
    
    environment {
        IMAGE_NAME = "backend"
        IMAGE_TAG = "v1"
        FULL_IMAGE_NAME = "${IMAGE_NAME}:${IMAGE_TAG}"
        CONTAINER_NAME = "COS_container"
        GIT_REPO_URL = 'https://github.com/Sylviahmar/COS.git'  // Replace with your actual repo URL
        GIT_CREDENTIALS_ID = 'github-token'  // Use the correct credentials ID for Jenkins
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code from GitHub...'
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/main']],
                    extensions: [],
                    userRemoteConfigs: [[
                        url: GIT_REPO_URL,
                        credentialsId: GIT_CREDENTIALS_ID
                    ]]
                ])
            }
        }
        
        stage('Build React Frontend Docker Image') {
            steps {
                echo 'Building React frontend Docker image...'
                script {
                    sh 'docker build -t react-frontend:v1 ./frontend'  // Adjust path to your frontend directory
                }
            }
        }
        
        stage('Build Selenium Tests Docker Image') {
            steps {
                echo 'Building Selenium tests Docker image...'
                script {
                    sh 'docker build -t selenium-tests:v1 ./tests/selenium'  // Adjust path to your Selenium test directory
                }
            }
        }
        
        stage('Run Selenium Tests') {
            steps {
                echo 'Running Selenium tests...'
                script {
                    sh 'docker run --rm selenium-tests:v1'  // This will run your tests inside a container
                }
            }
        }
        
        stage('Deploy with Docker Compose') {
            steps {
                echo 'Deploying application using Docker Compose...'
                script {
                    sh 'docker-compose -f docker-compose.yml up -d'  // Make sure the compose file is in the root directory
                }
            }
        }
        
        stage('Cleanup Old Containers (Optional)') {
            steps {
                echo 'Cleaning up old containers...'
                script {
                    sh "docker rm -f $CONTAINER_NAME || true"
                }
            }
        }
    }
    
    post {
        always {
            echo 'Cleaning up Docker resources...'
            sh 'docker-compose down'  // Clean up after deployment
        }
        success {
            echo 'Deployment completed successfully!'
        }
        failure {
            echo 'Deployment failed. Investigate the error.'
        }
    }
}