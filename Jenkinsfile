pipeline {
    agent any

    environment {
        IMAGE_NAME_FRONTEND = "react-frontend"
        IMAGE_TAG_FRONTEND = "v1"
        FULL_IMAGE_NAME_FRONTEND = "${IMAGE_NAME_FRONTEND}:${IMAGE_TAG_FRONTEND}"

        IMAGE_NAME_TESTS = "selenium-tests"
        IMAGE_TAG_TESTS = "v1"
        FULL_IMAGE_NAME_TESTS = "${IMAGE_NAME_TESTS}:${IMAGE_TAG_TESTS}"

        CONTAINER_NAME_FRONTEND = "react-frontend-container"
        CONTAINER_NAME_TESTS = "selenium-test-container"

        GIT_REPO_URL = 'https://github.com/Sylviahmar/COS.git'  // Your GitHub repo URL
        GIT_CREDENTIALS_ID = 'github-deploy-token'  // Use the correct credentials ID for Jenkins
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code from GitHub...'
                checkout([ 
                    $class: 'GitSCM', 
                    branches: [[name: '*/main']], 
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
                    sh 'docker build -t $FULL_IMAGE_NAME_FRONTEND ./frontend'
                }
            }
        }

        stage('Build Selenium Tests Docker Image') {
            steps {
                echo 'Building Selenium test runner Docker image...'
                script {
                    sh 'docker build -t $FULL_IMAGE_NAME_TESTS ./tests'
                }
            }
        }

        stage('Run Selenium Tests') {
            steps {
                echo 'Running Selenium tests...'
                script {
                    sh 'docker run --rm $FULL_IMAGE_NAME_TESTS'
                }
            }
        }

        stage('Deploy with Docker Compose') {
            steps {
                echo 'Deploying application using Docker Compose...'
                script {
                    sh 'docker-compose -f docker-compose.yml up -d'
                }
            }
        }

        stage('Cleanup Old Containers (Optional)') {
            steps {
                echo 'Cleaning up old containers...'
                script {
                    sh "docker rm -f $CONTAINER_NAME_FRONTEND || true"
                    sh "docker rm -f $CONTAINER_NAME_TESTS || true"
                }
            }
        }
    }

    post {
        always {
            echo 'Cleaning up Docker resources...'
            sh 'docker-compose down'
        }
    }
}
