pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Sylviahmar/COS.git'
            }
        }

        stage('Build') {
            steps {
                echo 'Building...'
                // Add actual build commands here (if needed)
            }
        }

        stage('Test') {
            steps {
                echo 'Running tests...'
                // You can run Selenium tests here later
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying to server...'
                // Example: deploy using SCP, Rsync, or move to a folder
                // For example, to copy files to a server:
                // sh 'scp -r * username@yourserver:/path/to/deploy'
            }
        }
    }
}
