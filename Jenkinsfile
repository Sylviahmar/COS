pipeline {
    agent any

    stages {
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t chatapp:v1 .'
            }
        }

        stage('Run Tests') {
            steps {
                sh 'echo "Running tests..."'
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying container using docker-compose...'
                script {
                    sh 'docker-compose down || true'
                    sh 'docker-compose up -d --build'
                }
            }
        }

        stage('Cleanup Old Container (Optional)') {
            steps {
                echo 'Cleaning up old Docker containers...'
                script {
                    sh '''
                        docker ps -aq --filter "name=chatapp" | xargs -r docker rm -f || true
                    '''
                }
            }
        }
    }
}
