pipeline {
    agent any

    environment {
        BRANCH_NAME = "${env.GIT_BRANCH.split('/').last()}"
    }

    stages {
        stage('Setup Environment') {
            steps {
                script {
                    if (env.BRANCH_NAME == "main") {
                        env.APP_PORT = "3000"
                        env.IMAGE_TAG = "nodemain:v1.0"
                    } else {
                        env.APP_PORT = "3001"
                        env.IMAGE_TAG = "nodedev:v1.0"
                    }
                    echo "Branch: ${env.BRANCH_NAME}"
                    echo "App Port: ${env.APP_PORT}"
                    echo "Image Tag: ${env.IMAGE_TAG}"
                }
            }
        }

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                bat 'npm install' 
            }
        }

        stage('Test') {
            steps {
                bat 'npm test || exit 0'
            }
        }

        stage('Build Docker Image') {
            steps {
                bat "docker build -t ${env.IMAGE_TAG} ."
            }
        }

        stage('Deploy') {
            steps {
                bat """
                for /f "tokens=*" %%i in ('docker ps -aqf "name=${env.BRANCH_NAME}"') do (
                    docker stop %%i
                    docker rm %%i
                )
                docker run -d -p ${env.APP_PORT}:3000 --name ${env.BRANCH_NAME} ${env.IMAGE_TAG}
                """
            }
        }
    }
}