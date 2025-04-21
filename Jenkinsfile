pipeline {
    agent any

    environment {
        GIT_REPO = 'https://github.com/Sylviahmar/COS.git'  // Replace with your actual repo
    }

    stages {
        stage('Checkout') {
            steps {
                // Use Jenkins credentials securely
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/main']],
                    userRemoteConfigs: [[
                        url: "${env.GIT_REPO}",
                        credentialsId: 'github-deploy-token'
                    ]]
                ])
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t selenium-test-runner .'
            }
        }

        stage('Run Tests with Docker Compose') {
            steps {
                sh 'docker-compose up --abort-on-container-exit'
            }
        }

        stage('Archive Results') {
            steps {
                // Only if you export JUnit XML format test reports
                junit 'reports/*.xml'
            }
        }
    }

    post {
        always {
            sh 'docker-compose down'
        }
    }
}
