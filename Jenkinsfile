pipeline {
    agent any

    environment {
        BRANCH_NAME = "${env.GIT_BRANCH.split('/').last()}"
        APP_PORT = BRANCH_NAME == "main" ? "3000" : "3001"
        IMAGE_TAG = BRANCH_NAME == "main" ? "nodemain:v1.0" : "nodedev:v1.0"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                echo "Building the Node.js app for branch ${BRANCH_NAME}"
                sh 'npm install'
            }
        }

        stage('Test') {
            steps {
                echo "Running tests..."
                sh 'npm test || true'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${IMAGE_TAG} ."
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    sh """
                       existing_container=\$(docker ps -aqf "name=${BRANCH_NAME}") || true
                       if [ ! -z "\$existing_container" ]; then
                           echo "Stopping container for ${BRANCH_NAME}"
                           docker stop \$existing_container || true
                           docker rm \$existing_container || true
                       fi
                       docker run -d -p ${APP_PORT}:3000 --name ${BRANCH_NAME} ${IMAGE_TAG}
                    """
                }
            }
        }
    }
}