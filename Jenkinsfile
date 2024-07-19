pipeline {
    agent none  // Define a top-level agent as none, since you'll specify agents for each stage
    
    tools {
        nodejs "node"
    }

    stages {
        stage('Retrieve Config File - Development') {
            agent {
                label 'development'
            }
            steps {
                script {
                    // Get the workspace directory
                    def workspaceDir = pwd()
                    
                    // Retrieve the managed config file and place it in the workspace
                    configFileProvider([configFile(fileId: 'firebase.production.json', targetLocation: "${workspaceDir}/firebase.production.json")]) {
                    }
                }
            }
        }
        stage('Retrieve Config File - Stage') {
            agent {
                label 'stage'
            }
            steps {
                script {
                    // Get the workspace directory
                    def workspaceDir = pwd()
                    
                    // Retrieve the managed config file and place it in the workspace
                    configFileProvider([configFile(fileId: 'firebase.production.json', targetLocation: "${workspaceDir}/firebase.production.json")]) {
                    }
                }
            }
        }
    }
}
