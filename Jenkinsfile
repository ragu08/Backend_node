pipeline {
    agent none

    tools {
        nodejs "node"
    }

    environment {
        APP_NAME = 'mws-multistage-sample'
        VERSION_NAME="1.0.0"
        BUILD_NUMBER = "${env.BUILD_NUMBER}"
        dockerHubRepo = 'stage-registry.dconag.com'
    }

    stages {
        stage('Checkout') {
            parallel {
                stage('Checkout Development Branch') {
                    agent { label 'jenkins' }
                    when {
                        branch 'development'
                    }
                    steps {
                        checkout([
                            $class: 'GitSCM',
                            branches: [[name: 'development']],
                            userRemoteConfigs: [[
                            url: 'https://github.com/ragu08/Backend_node.git',
                            credentialsId: 'github'
                        ]]
                        ])
                    }
                }
                stage('Checkout Release Branch') {
                    agent { label 'stage' }
                    when {
                        branch 'release'
                    }
                    steps {
                        checkout([
                            $class: 'GitSCM',
                            branches: [[name: 'release']],
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

                    // Retrieve the FireBase File and place it in the workspace
                    configFileProvider([configFile(fileId: 'firebase.development.json', targetLocation: "${workspaceDir}/firebase.development.json")]) {
                    }

                    // Retrieve the Environment File and plae it in the workspace
                    configFileProvider([configFile(fileId: '.env.development', targetLocation: "${workspaceDir}/.env.development")]) {
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

                    // Retrieve the FireBase File and place it in the workspace
                    configFileProvider([configFile(fileId: 'firebase.development.json', targetLocation: "${workspaceDir}/firebase.development.json")]) {
                    }

                    // Retrieve the Environment File and plae it in the workspace
                    configFileProvider([configFile(fileId: '.env.development', targetLocation: "${workspaceDir}/.env.development")]) {
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
        stage('Build Docker Image - Development') {
            when {
                branch 'development'
            }
            agent {
                label 'jenkins'
            }
            steps {
                script {
                    sh "docker build -t ${dockerHubRepo}/${APP_NAME}:${VERSION_NAME}.${BUILD_NUMBER} ."
                }
            }
        }
        stage('Build Docker Image - Stage') {
            when {
                branch 'release'
            }
            agent {
                label 'stage'
            }
            steps {
                script {
                    sh "docker build -t ${dockerHubRepo}/${APP_NAME}:${VERSION_NAME}.${BUILD_NUMBER} ."
                }
            }
        }
        stage('Push Image to Private Registry - Development') {
            when {
                branch 'development'
            }
            agent {
                label 'jenkins'
            }
            steps {
                script {
                    withDockerRegistry(credentialsId: 'dockerprivateregistry', url: 'https://stage-registry.dconag.com') {
                        sh 'docker push ${dockerHubRepo}/${APP_NAME}:${VERSION_NAME}.${BUILD_NUMBER}'
                    }
                }
            }
        }
        stage('Push Image to Private Registry - Stage') {
            when {
                branch 'release'
            }
            agent {
                label 'stage'
            }
            steps {
                script {
                    withDockerRegistry(credentialsId: 'dockerprivateregistry', url: 'https://stage-registry.dconag.com') {
                        sh 'docker push ${dockerHubRepo}/${APP_NAME}:${VERSION_NAME}.${BUILD_NUMBER}'
                    }
                }
            }
        }
        stage('Deploy to Development Server') {
            when {
                branch 'development'
            }
            agent {
                label 'jenkins'
            }
            steps {
                script {
                    // Stop and remove any existing container
                    sh """
                    docker stop ${APP_NAME} || true
                    docker rm ${APP_NAME} || true
                    """

                    // Pull the image from the private registry
                    withDockerRegistry(credentialsId: dockerprivateregistry, url: 'https://stage-registry.dconag.com') {
                        sh "docker pull ${DOCKERHUB_REPO}/${APP_NAME}:${VERSION_NAME}.${BUILD_NUMBER}"
                    }

                    // Start the new container
                    def dockerRunCommand = "docker run --name ${APP_NAME} --hostname dconag_api --network=sample --ip 172.18.0.3 -p 7101:3000 --env-file ./.env.development --restart=always -d ${DOCKERHUB_REPO}/${APP_NAME}:${VERSION_NAME}.${BUILD_NUMBER}"
                    sh dockerRunCommand
                }
            }
        }
    }
}
