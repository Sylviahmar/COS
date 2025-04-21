pipeline {
    agent any
    
    environment {
        // Define environment variables here
        DOCKER_REGISTRY = "your-registry-url"
        APP_VERSION = "${BUILD_NUMBER}"
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo "Checking out code from GitHub..."
                checkout scm
                
                // Verify repository structure
                sh 'ls -la'
            }
        }
        
        stage('Install Dependencies') {
            steps {
                echo "Installing required dependencies..."
                // Install docker-compose if not available
                sh '''
                if ! command -v docker-compose &> /dev/null; then
                    echo "Installing docker-compose..."
                    curl -L "https://github.com/docker/compose/releases/download/v2.23.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
                    chmod +x /usr/local/bin/docker-compose
                fi
                '''
            }
        }
        
        stage('Build Frontend Docker Image') {
            steps {
                echo "Building React frontend Docker image..."
                script {
                    // Verify directory exists before attempting to build
                    sh '''
                    if [ -d "./frontend" ]; then
                        docker build -t react-frontend:${APP_VERSION} ./frontend
                    else
                        echo "Frontend directory not found. Creating required structure..."
                        mkdir -p frontend
                        echo "ERROR: Frontend code is missing. Please add it to the repository."
                        exit 1
                    fi
                    '''
                }
            }
        }
        
        stage('Build Test Docker Image') {
            steps {
                echo "Building Selenium tests Docker image..."
                script {
                    sh '''
                    if [ -d "./tests" ]; then
                        docker build -t selenium-tests:${APP_VERSION} ./tests
                    else
                        echo "Tests directory not found. Creating required structure..."
                        mkdir -p tests
                        echo "ERROR: Test code is missing. Please add it to the repository."
                        exit 1
                    fi
                    '''
                }
            }
        }
        
        stage('Run Tests') {
            steps {
                echo "Running Selenium tests..."
                script {
                    try {
                        // Start the application services
                        sh 'docker-compose up -d'
                        
                        // Wait for services to be ready
                        sh 'sleep 10'
                        
                        // Run tests
                        sh 'docker run --network=host selenium-tests:${APP_VERSION}'
                        
                    } catch (Exception e) {
                        echo "Tests failed: ${e.message}"
                        currentBuild.result = 'UNSTABLE'
                    }
                }
            }
        }
        
        stage('Deploy Application') {
            when {
                expression { currentBuild.resultIsBetterOrEqualTo('UNSTABLE') }
            }
            steps {
                echo "Deploying with Docker Compose..."
                sh 'docker-compose up -d --build'
                
                // Wait for deployment to complete
                sh 'sleep 10'
                
                // Verify deployment
                sh 'docker-compose ps'
            }
        }
    }
    
    post {
        always {
            echo "Cleaning up Docker resources..."
            sh 'docker-compose down || true'
            
            // Clean up unused images to save disk space
            sh 'docker system prune -f || true'
        }
        success {
            echo "Pipeline completed successfully!"
        }
        failure {
            echo "Pipeline failed. Please check the logs for details."
        }
    }
}