pipeline {
    agent any
    
    tools {
        maven 'M3'
        // FIX: Tell Jenkins to install/use the 'docker' tool we just configured
        dockerTool 'docker' 
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
                    // DEBUG: List all files in the tools directory to see where 'docker' is hiding
                    sh "find /var/jenkins_home/tools/org.jenkinsci.plugins.docker.commons.tools.DockerTool -name docker"
                    
                    // The build command (might still fail, but we need the logs above)
                    sh "docker build -t ${IMAGE_NAME}:${BUILD_NUMBER} ."
                }
            }
        }
    }
    
    post {
        always {
            sh "docker rmi ${IMAGE_NAME}:${BUILD_NUMBER} || true"
        }
    }
}
