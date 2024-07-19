pipeline {
    agent none

    tools {
        nodejs "node"
    }

    environment {
        APP_NAME = 'mws-dconag-api-jenkins-demo'
        VERSION_NAME="1.0.0"
        BUILD_NUMBER = "${env.BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            parallel {
                stage('Checkout Development Branch') {
                    when {
                        branch 'development'
                    }
                    agent {
                        label 'jenkins'
                    }
                    steps {
                        checkout([
                            $class: 'GitSCM',
                            branches: [[name: 'refs/heads/development']],
                            userRemoteConfigs: [[
                            url: 'https://github.com/ragu08/Backend_node.git',
                            credentialsId: 'github'
                        ]]
                        ])
                    }
                }
                stage('Checkout Release Branch') {
                    when {
                        branch 'release'
                    }
                    agent {
                        label 'stage'
                    }
                    steps {
                        checkout([
                            $class: 'GitSCM',
                            branches: [[name: 'refs/heads/release']],
                            userRemoteConfigs: [[
                            url: 'https://github.com/ragu08/Backend_node.git',
                            credentialsId: 'github'
                        ]]
                        ])
                    }
                }
            }
        }
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
                    configFileProvider([configFile(fileId: 'firebase.development.json', targetLocation: "${workspaceDir}/firebase.development.json")]) {
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
        stage('Run Build Script - Development') {
            when {
                branch 'development'
            }
            agent {
                label 'jenkins'
            }
            steps {
                script {
                    // Ensure the build script is executable and run it
                    sh 'chmod +x build.sh'
                    sh './build.sh'
                }
            }
        }
        stage('Run Build Script - Stage') {
            when {
                branch 'release'
            }
            agent {
                label 'stage'
            }
            steps {
                script {
                    // Ensure the build script is executable and run it
                    sh 'chmod +x build.sh'
                    sh './build.sh'
                }
            }
        }
    }
}
