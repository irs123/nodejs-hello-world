properties ([
  buildDiscarder(logRotator(artifactDaysToKeepStr: '30', artifactNumToKeepStr: '', daysToKeepStr: '90', numToKeepStr: '')),
  disableConcurrentBuilds()
])
pipeline {
  agent {
    kubernetes {
      label "data-txm-atm-${UUID.randomUUID().toString()}"
      yaml """
        apiVersion: v1
        kind: Pod
        metadata:
          labels:
            jenkins: jenkins-pipeline
        spec:
          containers:
          - name: jnlp
            image: jenkins/jnlp-slave
            ttyEnabled: true
          - name: node14
            image: node:14-alpine
            #imagePullPolicy: Always
            command:
              - cat
            tty: true
            resources:
                requests:
                  memory: "500Mi"
                  cpu: "200m"
                limits:
                  memory: "1000Mi"
                  cpu: "400m"
          - name: kaniko
            image: gcr.io/kaniko-project/executor:debug
            command:
            - sleep
            args:
            - 9999999
            volumeMounts:
            - name: kaniko-secret
              mountPath: /kaniko/.docker
          restartPolicy: Never
          volumes:
          - name: kaniko-secret
            secret:
                secretName: dockercred
                items:
                - key: .dockerconfigjson
                  path: config.json          
      """
    }
  }
  environment {
    registry="https://hub.docker.com/repository/docker/irs123/kaniko-test"

    appName = "cma-atm-api"
  }
  stages {
    stage ('GitFlow') {
      steps {
        script {
          echo "Checking git workflow"
          git url: 'https://github.com/irs123/nodejs-hello-world', branch: 'main'
          echo "Branch name is : ${env.BRANCH_NAME}"
           
        }
      }
    }
    stage('Build') {
      steps {
        container('node14') {
          echo "building the artifact"
          script{
           sh'''
           npm install
           '''
          }
        }
      }
    }
     stage('Docker build and publish') {
      steps {
        container('kaniko') {
          echo "building the artifact"
          script{
         sh '''
            /kaniko/executor --context `pwd` --destination gcr.io/firm-retina-349011/hello-world:v1.1
          '''
          }
        }
      }
    }

  }
  
}

