pipeline {
    agent any

    environment {
        IMAGE_NAME = "chatapp"
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Cloning repository...'
                checkout scm
            }
        }

        stage('Install') {
            steps {
                echo 'Installing dependencies...'
                sh 'npm install'
            }
        }

        stage('Build') {
            steps {
                echo 'Building the application...'
                sh 'npm run build'
            }
        }

        stage('Cleanup Old Container (Optional)') {
            steps {
                echo 'Removing existing Docker container (if any)...'
                script {
                    // Attempt to stop and remove the existing container
                    sh 'docker rm -f ${IMAGE_NAME} || true'
                }
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying application using Docker Compose...'
                script {
                    sh 'docker-compose -f docker-compose.yml down || true'
                    sh 'docker-compose -f docker-compose.yml up -d --build'
                }
            }
        }
    }

    post {
        success {
            echo '🚀 Deployment successful!'
        }
        failure {
            echo '❌ Deployment failed.'
        }
    }
}
