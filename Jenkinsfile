pipeline {
  agent none
  options {
    disableConcurrentBuilds()
    buildDiscarder(logRotator(numToKeepStr: '10'))
    timeout(time: 15, unit: 'MINUTES')
    skipDefaultCheckout()
  }

  stages {
    stage('🏗️ Standard build') {
      agent { label 'Linux-Office03' }
      environment {
        OP_CLI_PATH = '/usr/local/bin/'
        ARTIFACTORY_PRIVATE_USERNAME = 'op://Jenkins/Nexus/username'
        ARTIFACTORY_PRIVATE_PASSWORD = 'op://Jenkins/Nexus/password'
      }
      steps {
        script {
          checkout([$class: 'GitSCM', branches: scm.branches, extensions: scm.extensions + [[$class: 'CleanCheckout']], userRemoteConfigs: scm.userRemoteConfigs])
          docker.image('gradle:8').inside('') {
            withEnv(["GRADLE_USER_HOME=/tmp/.gradle"]) {
              withSecrets() {
                sh "./gradlew build"
              }
            }
          }
        }
      }
    }

    stage('📦 Docker') {
      when { branch 'master' }
      agent { label 'Linux-Office03' }
      steps {
        script {
          sh 'docker build -t docker.rssw.eu/mcp/sonarqube:latest -f rssw.Dockerfile .'
          // Local images for now
          // sh 'docker push docker.rssw.eu/mcp/sonarqube:latest'
        }
      }
    }
  }

  post {
    unstable {
      script {
        mail body: "Check console output at ${BUILD_URL}console", to: "jenkins-reports@riverside-software.fr", subject: "sonarqube-mcp ${BRANCH_NAME} build is unstable"
      }
    }
    failure {
      script {
        mail body: "Check console output at ${BUILD_URL}console", to: "jenkins-reports@riverside-software.fr", subject: "sonarqube-mcp ${BRANCH_NAME} build failure"
      }
    }
    fixed {
      script {
        mail body: "Console output at ${BUILD_URL}console", to: "jenkins-reports@riverside-software.fr", subject: "sonarqube-mcp ${BRANCH_NAME} build is back to normal"
      }
    }
  }
}
