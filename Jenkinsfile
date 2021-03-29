pipeline {
    agent any
    parameters {
        string(name: 'EKSCLUSTERNAME', defaultValue: 'ekscluster', description: 'Enter Name for EKS Cluster')
        string(name: 'EKSNODENAME', defaultValue: 'eksnode', description: 'Enter name for EKS node group')
        string(name: 'TWORKSPACE', defaultValue: 'default', description: 'Enter Terraform workspace name')
        string(name: 'INSTANCETYPE', defaultValue: 't3.medium', description: 'Enter Instance type')
        booleanParam(name: 'destroy', defaultValue: true, description: '')
    }
    stages {
        stage('Git checkout') { 
            steps {
                sh 'whoami'
                git credentialsId: '0d114c74-a3e2-4fd3-a050-f96608897466', url: 'https://github.com/Dhanabalan-pop/EKS.git'
            }
        }
        stage('Terraform Initialization') { 
                when {
                expression {
                    params.destroy==false
                }
            }
            steps {
                sh 'terraform workspace new $TWORKSPACE'
                sh 'terraform init'
            }
        }
        stage('Check Terraform plan') { 
            when {
                expression {
                    params.destroy==false
                }
            }
            steps {
                sh 'terraform plan -var eks_name=$EKSCLUSTERNAME -var eksnode_name=$EKSNODENAME -var 'instance_types=["$INSTANCETYPE"]''
            }
        }
        stage('Apply the terraform code') {
            when {
                expression {
                    params.destroy==false
                }
            }
            steps {
                sh 'terraform apply -var eks_name=$EKSCLUSTERNAME -var eksnode_name=$EKSNODENAME -var 'instance_types=["$INSTANCETYPE"]' -auto-approve'
            }
        }
        stage('Destroy the Infrastructure created by Terraform'){
            when {
                expression {
                    params.destroy
                }
            }
            steps {
                sh 'terraform workspace select $TWORKSPACE'
                sh 'terraform init'
                sh 'terraform destroy -auto-approve'
            }
        }
    }
}
