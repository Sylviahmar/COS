pipeline {
  agent any

  environment {
    IMAGE_NAME = "chatapp"
    CONTAINER_NAME = "chatapp"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build Docker Image') {
      steps {
        sh 'docker build -t $IMAGE_NAME .'
      }
    }

    stage('Run Tests') {
      steps {
        sh 'echo "No tests to run"'
      }
    }

    stage('Deploy') {
      steps {
        sh '''
          docker rm -f $CONTAINER_NAME || true
          docker run -d --name $CONTAINER_NAME -p 3000:3000 $IMAGE_NAME
        '''
      }
    }

    stage('Cleanup Old Container (Optional)') {
      steps {
        echo 'Cleanup already handled before deploy stage.'
      }
    }
  }
}
