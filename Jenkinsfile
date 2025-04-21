pipeline {
  agent any

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build') {
      steps {
        echo 'Building Docker images…'
        sh 'docker-compose -f docker-compose.yml build'
      }
    }

    stage('Deploy') {
      steps {
        echo 'Deploying…'
        script {
          sh """
            docker-compose -f docker-compose.yml down --remove-orphans
            docker-compose -f docker-compose.yml up -d --build
          """
        }
      }
    }
  }

  post {
    always {
      echo 'Post-build cleanup…'
      sh 'docker-compose -f docker-compose.yml down --remove-orphans'
    }
  }
}
