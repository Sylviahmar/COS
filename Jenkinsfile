pipeline {
    agent any

    tools {
        nodejs "NodeJS"  // Make sure you've configured NodeJS in Jenkins global tools
    }

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/Sylviahmar/COS.git'  // your repo URL
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Lint or Test (Optional)') {
            steps {
                echo 'Skipping test stage for now...'
                // sh 'npm test'  // Uncomment if you have tests
            }
        }

        stage('Run App') {
            steps {
                echo 'Running Node.js app...'
                sh 'node src/app.js'
            }
        }
    }
}
