pipeline {
    agent any
    
    tools {
        maven 'M3'
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
                    // UPDATED: Using Docker v27.3.1 to match your modern Windows Daemon
                    sh 'curl -LO https://download.docker.com/linux/static/stable/x86_64/docker-27.3.1.tgz'
                    
                    sh 'tar xzvf docker-27.3.1.tgz'
                    
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
                    sh "./docker/docker build -t ${IMAGE_NAME}:${BUILD_NUMBER} ."
                }
            }
        }
    }
    
    post {
        always {
            sh "./docker/docker rmi ${IMAGE_NAME}:${BUILD_NUMBER} || true"
            // Cleanup the specific version file
            sh "rm -rf docker docker-27.3.1.tgz"
        }
    }
}
