pipeline {
    agent any
    
    stages {
        stage('Checkout') {
            steps {
                echo "Checking out code..."
                checkout scm
                sh 'ls -la'
            }
        }
        
        stage('Build') {
            steps {
                echo "Building application..."
                sh '''
                # Simple check if Docker exists
                which docker || echo "Docker not found"
                
                # Simple docker build without fancy options
                docker build -t simple-app:latest .
                '''
            }
        }
        
        stage('Test') {
            steps {
                echo "Running basic tests..."
                sh '''
                # Run the container in detached mode
                docker run -d --name test-container -p 8080:80 simple-app:latest
                
                # Check if it's running
                docker ps | grep test-container
                
                # Stop and remove the container
                docker stop test-container
                docker rm test-container
                '''
            }
        }
        
        stage('Deploy') {
            steps {
                echo "Deploying application..."
                sh '''
                # Stop any existing container
                docker stop prod-container || true
                docker rm prod-container || true
                
                # Run the new container
                docker run -d --name prod-container -p 80:80 simple-app:latest
                
                # Verify deployment
                docker ps | grep prod-container
                '''
            }
        }
    }
    
    post {
        always {
            echo "Cleaning up..."
            sh '''
            # Clean up test containers
            docker stop test-container || true
            docker rm test-container || true
            
            # Clean up resources
            docker system prune -f || true
            '''
        }
    }
}