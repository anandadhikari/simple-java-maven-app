pipeline {
    agent any
    tools {
        maven 'M3' 
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Build') {
            steps {
                sh 'mvn clean compile' 
            }
        }
        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }
        stage('Package') {
            steps {
                sh 'mvn package -DskipTests' 
            }
        }
    }
    post {
        always {
            archiveArtifacts artifacts: 'target/**/*.jar', fingerprint: true
            junit 'target/surefire-reports/*.xml'
        }
    }
}
