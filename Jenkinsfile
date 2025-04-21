pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'your_image_name'  // Update with your image name
    }
    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code...'
                git branch: 'main', url: 'https://github.com/Sylviahmar/COS.git'
            }
        }
        stage('Build') {
            steps {
                echo 'Building Docker Compose services...'
                // Use sh instead of bat for Linux/Unix-based environments
                sh '''
                docker-compose -f docker-compose.yml build
                '''
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying application...'
                // Use sh for running Docker Compose up
                sh '''
                docker-compose -f docker-compose.yml up -d
                '''
            }
        }
    }
    post {
        always {
            echo 'Cleaning up Docker Compose services...'
            sh '''
            docker-compose -f docker-compose.yml down
            '''
        }
    }
}
