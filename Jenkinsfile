pipeline {
    agent any

    environment {
        IMAGE_NAME = "chatapp"
        IMAGE_TAG = "v1"
        FULL_IMAGE_NAME = "${IMAGE_NAME}:${IMAGE_TAG}"
        CONTAINER_NAME = "chatapp_container"
        GIT_REPO_URL = 'https://github.com/Sylviahmar/COS.git'
        GIT_CREDENTIALS_ID = 'my-github-token'
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
                        url: "${GIT_REPO_URL}",
                        credentialsId: "${GIT_CREDENTIALS_ID}"
                    ]]
                ])
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                script {
                    sh "docker build -t $FULL_IMAGE_NAME ."
                }
            }
        }

        stage('Run Tests') {
            steps {
                echo 'Running tests (if any)...'
                // Add test commands here if needed
                // Example: sh "docker run --rm $FULL_IMAGE_NAME npm test"
            }
        }

        stage('Cleanup Old Container (Optional)') {
            steps {
                echo 'Cleaning up old containers...'
                script {
                    sh "docker rm -f $CONTAINER_NAME || true"
                }
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying application using Docker Compose...'
                script {
                    sh "docker-compose -f docker-compose.yml down || true"
                    sh "docker-compose -f docker-compose.yml up -d --build"
                }
            }
        }
    }
}
