pipeline {
    agent any
    
    tools {
        maven 'M3'
        // REMOVED: dockerTool 'docker' (We will handle this manually)
    }
    
    environment {
        SONAR_ORG = 'anandadhikari' 
        SONAR_PROJECT = 'anandadhikari_simple-java-maven-app'
        SONAR_TOKEN = credentials('sonar-token')
        IMAGE_NAME = 'my-java-app'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Setup Docker Client') {
            steps {
                echo 'Setting up Docker Client locally...'
                script {
                    // 1. Download the static binary (v24.0.7)
                    sh 'curl -LO https://download.docker.com/linux/static/stable/x86_64/docker-24.0.7.tgz'
                    
                    // 2. Extract it
                    sh 'tar xzvf docker-24.0.7.tgz'
                    
                    // 3. Verify it works
                    sh './docker/docker --version'
                }
            }
        }
        
        stage('Build & Test') {
            steps {
                sh 'mvn clean package' 
            }
        }

        stage('Code Quality') {
            steps {
                echo 'Checking Code Quality...'
                sh '''
                  mvn org.sonarsource.scanner.maven:sonar-maven-plugin:sonar \
                  -Dsonar.projectKey=${SONAR_PROJECT} \
                  -Dsonar.organization=${SONAR_ORG} \
                  -Dsonar.host.url=https://sonarcloud.io \
                  -Dsonar.token=${SONAR_TOKEN}
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker Image...'
                script {
                    // USE THE LOCAL BINARY: ./docker/docker
                    sh "./docker/docker build -t ${IMAGE_NAME}:${BUILD_NUMBER} ."
                }
            }
        }
    }
    
    post {
        always {
            // Cleanup using the local binary
            sh "./docker/docker rmi ${IMAGE_NAME}:${BUILD_NUMBER} || true"
            // Clean up the downloaded docker folder
            sh "rm -rf docker docker-24.0.7.tgz"
        }
    }
}
