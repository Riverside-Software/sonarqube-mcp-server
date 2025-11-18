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
      steps {
        script {
          checkout([$class: 'GitSCM', branches: scm.branches, extensions: scm.extensions + [[$class: 'CleanCheckout']], userRemoteConfigs: scm.userRemoteConfigs])

          docker.image('eclipse-temurin:21-jdk-ubi10-minimal').inside('') {
            sh "./gradlew build"
          }
        }
      }
    }

    stage('📦 Docker') {
      when { branch 'master' }
      agent { label 'Linux-Office03' }
      steps {
        script {
          sh "docker build -t docker.rssw.eu/mcp/sonarqube:latest -f rssw.Dockerfile"
          sh "docker push docker.rssw.eu/mcp/sonarqube:latest"
        }
      }
    }
  }
}