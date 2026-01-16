pipeline {
    agent any
    
    tools {
        maven 'M3' 
    }
    
    environment {
        // Keep your SonarCloud credentials here
        SONAR_ORG = 'anandadhikari' 
        SONAR_PROJECT = 'anandadhikari_simple-java-maven-app'
        SONAR_TOKEN = credentials('sonar-token')
        
        // Define our image name
        IMAGE_NAME = 'my-java-app'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
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
                // This command runs INSIDE the Jenkins container, 
                // but talks to your Windows Docker Desktop via the socket mount.
                script {
                    sh "docker build -t ${IMAGE_NAME}:${BUILD_NUMBER} ."
                }
            }
        }
    }
    
    post {
        always {
            // Clean up: Delete the image to save space on your laptop
            sh "docker rmi ${IMAGE_NAME}:${BUILD_NUMBER} || true"
        }
    }
}
