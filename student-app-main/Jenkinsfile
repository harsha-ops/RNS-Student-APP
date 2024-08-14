pipeline {
    
    agent {
        label "build-server"
    }

    tools {
        // Install the Maven version configured as "M3" and add it to the path.
        maven "maven3"
    }

    stages {
        stage('Prepare-Env') {
            steps {
                // Get some code from a GitHub repository
                git branch: 'main', credentialsId: 'gitlab', url: 'https://gitlab.com/rns-app/student-app.git'

                // Run Maven on a Unix agent.
                sh "mvn clean compile"
            }
        }
        
        stage('Pre-Deployment-Testing') {
            steps {
                
                sh "echo 2 | sudo alternatives --config java"
                sh "java -version"
                // Run Maven on a Unix agent.
                sh "mvn clean test"
            }
            post{
                success{
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }
        
        stage('Packaging') {
            steps {
                
                sh "echo 1 | sudo alternatives --config java"
                sh "java -version"
                // Run Maven on a Unix agent.
                sh "mvn clean package -DskipTests"
            }
            post{
                success{
                    archiveArtifacts artifacts: '**/*.war', followSymlinks: false
                }
            }
        }
        
        stage('DB Schema') {
            steps {
                
                ansiblePlaybook become: true, becomeUser: 'devops', installation: 'ansible', inventory: 'ansible/hosts', playbook: 'ansible/create_db_schema.yml'
            }
        }
        
        stage('Application Deployment') {
            steps {
                
                sh "cp target/*.war ansible/files/student.war"
                ansiblePlaybook become: true, becomeUser: 'devops', installation: 'ansible', inventory: 'ansible/hosts', playbook: 'ansible/deploy_war_file_tomcat.yml'
            }
        }
        
        stage('Integration Testing') {
            steps {
                
                sh "echo 2 | sudo alternatives --config java"
                sh "java -version"
                // Run Maven on a Unix agent.
                sh "mvn clean verify"
            }
        }
    }
}
