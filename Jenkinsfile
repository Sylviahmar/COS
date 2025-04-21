pipeline {
    agent any
    
    environment {
        // Define environment variables
        APP_NAME = "chatapp"
        APP_VERSION = "${BUILD_NUMBER}"
        DOCKER_COMPOSE_VERSION = "2.23.0"
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo "Checking out code from GitHub..."
                checkout scm
                
                // List repository contents to verify checkout
                sh 'ls -la'
            }
        }
        
        stage('Setup Environment') {
            steps {
                echo "Setting up build environment..."
                // Check if docker is installed
                sh '''
                if ! command -v docker &> /dev/null; then
                    echo "Docker is not installed or not in PATH"
                    exit 1
                fi
                
                # Ensure docker-compose is available
                if ! command -v docker-compose &> /dev/null; then
                    echo "docker-compose not found, attempting to install..."
                    curl -L "https://github.com/docker/compose/releases/download/v${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
                    chmod +x /usr/local/bin/docker-compose
                    docker-compose --version
                fi
                '''
            }
        }
        
        stage('Build Docker Image') {
            steps {
                echo "Building Docker image..."
                script {
                    try {
                        // Check if Dockerfile exists
                        sh 'test -f Dockerfile || (echo "Dockerfile not found in repository" && exit 1)'
                        
                        // Build the Docker image
                        sh "docker build -t ${APP_NAME}:v${APP_VERSION} ."
                        
                        // Tag the image for potential registry push
                        sh "docker tag ${APP_NAME}:v${APP_VERSION} ${APP_NAME}:latest"
                    } catch (Exception e) {
                        echo "Build failed: ${e.message}"
                        error "Docker build failed. See logs for details."
                    }
                }
            }
        }
        
        stage('Run Tests') {
            steps {
                echo "Running application tests..."
                script {
                    try {
                        // If you have a separate test container or test commands
                        // Run them here - for now we'll simply check if the image works
                        sh "docker run --rm -d --name test-${APP_NAME} -p 8080:80 ${APP_NAME}:v${APP_VERSION}"
                        
                        // Wait for container to start
                        sh "sleep 5"
                        
                        // Simple test to check if container is running
                        sh "docker ps | grep test-${APP_NAME}"
                        
                        // Stop the test container
                        sh "docker stop test-${APP_NAME} || true"
                    } catch (Exception e) {
                        sh "docker stop test-${APP_NAME} || true"
                        echo "Tests failed: ${e.message}"
                        error "Test stage failed. See logs for details."
                    }
                }
            }
        }
        
        stage('Deploy') {
            steps {
                echo "Deploying application..."
                script {
                    try {
                        // Check if docker-compose.yml exists
                        sh 'test -f docker-compose.yml || (echo "docker-compose.yml not found in repository" && exit 1)'
                        
                        // Set environment variables for docker-compose
                        sh '''
                        export APP_VERSION=${APP_VERSION}
                        export APP_NAME=${APP_NAME}
                        
                        # Deploy with docker-compose
                        docker-compose up -d
                        '''
                        
                        // Verify deployment
                        sh "docker-compose ps"
                    } catch (Exception e) {
                        echo "Deployment failed: ${e.message}"
                        error "Deploy stage failed. See logs for details."
                    }
                }
            }
        }
    }
    
    post {
        always {
            echo "Cleaning up resources..."
            // Clean up containers and images that might have been created during the build
            sh '''
            # Try to bring down docker-compose services if docker-compose.yml exists
            if [ -f docker-compose.yml ]; then
                docker-compose down || true
            fi
            
            # Remove the test container if it exists
            docker rm -f test-${APP_NAME} || true
            
            # Prune unused resources to save space
            docker system prune -f || true
            '''
        }
        success {
            echo "Pipeline completed successfully!"
        }
        failure {
            echo "Pipeline failed. Please check the logs for details."
        }
    }
}