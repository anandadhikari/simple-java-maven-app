pipeline {
    agent any
    
    tools {
        maven 'M3' 
    }
    
    // Define environment variables for SonarCloud
    environment {
        // REPLACE THESE WITH YOUR ACTUAL VALUES FROM STEP 9.1
        SONAR_ORG = 'anandadhikari' 
        SONAR_PROJECT = 'simple-java-maven-app'
        
        // This automatically pulls the secret 'sonar-token' we saved in Step 9.2
        SONAR_TOKEN = credentials('sonar-token')
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

        stage('Code Quality') {
            steps {
                echo 'Checking Code Quality on SonarCloud...'
                // FIX: Use the full plugin name (GroupId:ArtifactId:Goal)
                sh '''
                  mvn org.sonarsource.scanner.maven:sonar-maven-plugin:sonar \
                  -Dsonar.projectKey=${SONAR_PROJECT} \
                  -Dsonar.organization=${SONAR_ORG} \
                  -Dsonar.host.url=https://sonarcloud.io \
                  -Dsonar.token=${SONAR_TOKEN}
                '''
            }
        }

        stage('Package') {
            steps {
                sh 'mvn package -DskipTests' 
            }
        }
    }
}
