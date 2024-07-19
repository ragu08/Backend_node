pipeline {
    agent none

    tools {
        nodejs "node"
    }

    stages {
        stage('Retrieve Config File - Development') {
            when {
                branch 'development'
            }
            agent {
                label 'jenkins'
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
            when {
                branch 'release'
            }
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
