pipeline {
    agent none

    stages {

        stage("Build & Test NestJS") {
            agent {
                docker {
                    image "node:22"
                    args "-u root:root"   // evita problemas de permisos en Linux
                }
            }
            steps {
                sh 'echo "Inicio pipeline"'
                sh 'npm install'
                sh 'npm run lint'
                sh 'npm run test:cov'
                sh 'npm run build'
            }
        }

        stage("Build Docker image") {
            agent any
            steps {
                sh """
                    docker build \
                        -t carlospva/backend-test:latest \
                        -t carlospva/backend-test:${env.BUILD_NUMBER} \
                        .
                """

                // Push a DockerHub
                script {
                    docker.withRegistry("https://index.docker.io/v1/", "id_credencial_jenkins") {
                        sh "docker push carlospva/backend-test:latest"
                        sh "docker push carlospva/backend-test:${env.BUILD_NUMBER}"
                    }
                }

                // Push al GitHub Container Registry
                script {
                    docker.withRegistry("https://ghcr.io", "credencial-github") {
                        sh "docker tag carlospva/backend-test:latest ghcr.io/carlospva/backend-test:latest"
                        sh "docker tag carlospva/backend-test:${env.BUILD_NUMBER} ghcr.io/carlospva/backend-test:${env.BUILD_NUMBER}"

                        sh "docker push ghcr.io/carlospva/backend-test:latest"
                        sh "docker push ghcr.io/carlospva/backend-test:${env.BUILD_NUMBER}"
                    }
                }
            }
        }

        stage("Fin del pipeline") {
            steps {
                echo "Pipeline finalizado correctamente"
            }
        }
    }
}
