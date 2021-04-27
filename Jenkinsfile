pipeline {
      /*agent { 
        kubernetes {
            label 'jenkins-slave'
        }      
    } */
     agent {
    kubernetes {
      label 'jenkins-slave'
      defaultContainer 'jnlp'
      yaml """
apiVersion: v1
kind: Pod
metadata:
labels:
  component: ci
spec:
  # Use service account that can deploy to all namespaces
  serviceAccountName: jenkins
  containers:
  - name: terraform
    image: hashicorp/terraform:0.14.8
    command:
    - cat
    tty: true
  - name: kubectl
    image: gcr.io/cloud-builders/kubectl
    command:
    - cat
    tty: true
  - name: helm-kubectl-awscli
    image: jshimko/kube-tools-aws:latest
    command:
    - cat
    tty: true
  - name: checkov
    image: bridgecrew/checkov
    command:
    - cat
    tty: true
"""
}
  }
    environment {
        AWS_ACCESS_KEY_ID     = credentials('awsaccesskey')
        AWS_SECRET_ACCESS_KEY = credentials('awssecretkey')
    }
    parameters {
        string(name: 'EKSCLUSTERNAME', defaultValue: 'ekscluster', description: 'Enter Name for EKS Cluster')
        string(name: 'EKSNODENAME', defaultValue: 'eksnode', description: 'Enter name for EKS node group')
        string(name: 'TWORKSPACE', defaultValue: 'default', description: 'Enter Terraform workspace name')
        string(name: 'INSTANCETYPE', defaultValue: '["t3.medium"]', description: 'Enter Instance type')
        booleanParam(name: 'destroy', defaultValue: true, description: 'Select the checkbox if you want to destroy the infrastructure')
        booleanParam(name: 'existingvpc', defaultValue: true, description: 'Select the checkbox if you want to use existing vpc')
        string(name: 'VPCCIDR', defaultValue: '10.0.0.0/20', description: 'Enter CIDR in case of creating new VPC')
        text(name: 'PRIVATESUBNETCIDR', defaultValue: '["10.0.2.0/24","10.0.3.0/24","10.0.4.0/24"]', description: 'Enter CIDR for three private subnet')
        text(name: 'EXISTINGSUBNETS', defaultValue: '["subnet-0c0cc3f9ce44896ad","subnet-05f3194963280a40a","subnet-0dc802a472d559797"]', description: 'Enter existing subnet ID')
        string(name: 'PUBLICSUBNETCIDR', defaultValue: '["10.0.5.0/24","10.0.6.0/24","10.0.7.0/24"]', description: 'Enter CIDR for public subnet')
        string(name: 'MINNODE', defaultValue: '2', description: 'Enter minimum node count for EKS cluster')
        string(name: 'MAXNODE', defaultValue: '4', description: 'Enter maximum node count for EKS cluster')
        string(name: 'DESIREDNODE', defaultValue: '2', description: 'Enter desired node count for EKS cluster')
    }
    stages {
        stage('Git checkout') { 
            steps{
                sh 'whoami'
                git branch: 'master', credentialsId: '6558272a-3027-44cb-8bfc-a25b9cab9f45', url: 'https://github.com/Dhanabalan-pop/EKS.git'
        }
        }
         stage('checkov') { 
            steps{
                container('checkov'){
                sh "checkov -d . -o junitxml > result.xml || true"
                junit "result.xml"
        }
        }
         }
        stage('Terraform Initialization') { 
                when {
                expression {
                    params.destroy==false
                }
            }
            steps{
                container('terraform'){
                    sh 'terraform init'
                    sh 'terraform workspace select $TWORKSPACE || terraform workspace new $TWORKSPACE'
        }
    }
        }
        stage('Check Terraform plan') { 
            when {
                expression {
                    params.destroy==false
                }
            }
            steps {
                container('terraform'){
                sh 'export TF_WORKSPACE=$TWORKSPACE'
                sh 'terraform plan -var existingvpc=$existingvpc -var existingsubnets=$EXISTINGSUBNETS -var eks_name=$EKSCLUSTERNAME -var eksnode_name=$EKSNODENAME -var instance_types=$INSTANCETYPE -var vpc_cidr=$VPCCIDR -var public_subnets_cidr=$PUBLICSUBNETCIDR -var private_subnets_cidr=$PRIVATESUBNETCIDR -var workspace=$TWORKSPACE -var minnode=$MINNODE -var maxnode=$MAXNODE -var desirednode=$DESIREDNODE -out $TWORKSPACE.out'
                sh 'terraform show -no-color $TWORKSPACE.out > $TWORKSPACE.txt'
            }
            }
        }
        stage('Apply the terraform code') {
            when {
                expression {
                    params.destroy==false
                }
            }
            steps{
                container('terraform') {
                sh 'terraform apply $TWORKSPACE.out'
                script {
                EKSNAME = sh (
                script: 'terraform output EKSclustername',
                returnStdout: true).trim()
                echo "${EKSNAME}"
               }
               script {
                EKSCLUSTERAUTOSCALERARN = sh (
                script: 'terraform output EKSclusterautoscalerrole',
                returnStdout: true).trim()
                echo "${EKSCLUSTERAUTOSCALERARN}"
               }
             }      
            }
        }
        stage('Run Kubectl and Helm scripts') {
            when {
                expression {
                    params.destroy==false
                }
            }
            steps {
                container('helm-kubectl-awscli'){
                sh 'whoami'
                sh 'aws configure set region us-west-1'
                sh 'aws configure set region us-west-1'
                sh 'aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID'
                sh 'aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY'
                sh 'aws configure list'
                sh 'aws configure list'
                sh "bash scripts/kubectl.sh $EKSNAME"
                sh 'bash scripts/helm.sh'
                sh 'bash scripts/kube-dashboard.sh'
                sh "bash scripts/eks-autoscaler.sh $EKSCLUSTERAUTOSCALERARN $EKSNAME"
                sh  'bash scripts/ingress.sh'
             }      
            }
        }
        stage('Destroy the Infrastructure created by Terraform'){
            when {
                expression {
                    params.destroy
                }
            }
            steps{
                container(terraform) {
                sh 'terraform workspace select $TWORKSPACE'
                sh 'terraform init'
                sh 'terraform destroy -auto-approve'
            }
        }
        }
    }
}
