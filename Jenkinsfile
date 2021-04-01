pipeline {
    agent any
    parameters {
        string(name: 'EKSCLUSTERNAME', defaultValue: 'ekscluster', description: 'Enter Name for EKS Cluster')
        string(name: 'EKSNODENAME', defaultValue: 'eksnode', description: 'Enter name for EKS node group')
        string(name: 'TWORKSPACE', defaultValue: 'default', description: 'Enter Terraform workspace name')
        string(name: 'INSTANCETYPE', defaultValue: '["t3.medium"]', description: 'Enter Instance type')
        booleanParam(name: 'destroy', defaultValue: true, description: 'Select the checkbox if you want to destroy the infrastructure')
        string(name: 'VPCCIDR', defaultValue: '0.0.0.0/0', description: 'Enter CIDR in case of creating new VPC')
        text(name: 'PRIVATESUBNETCIDR', defaultValue: '["0.0.0.0/0","0.0.0.0/0","0.0.0.0/0"]', description: 'Enter CIDR for three private subnet')
        string(name: 'PUBLICSUBNETCIDR', defaultValue: '0.0.0.0/0', description: 'Enter CIDR for public subnet')
        string(name: 'MINNODE', defaultValue: 'default', description: 'Enter minimum node count for EKS cluster')
        string(name: 'MAXNODE', defaultValue: 'default', description: 'Enter maximum node count for EKS cluster')
        string(name: 'DESIREDNODE', defaultValue: 'default', description: 'Enter desired node count for EKS cluster')
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
                sh 'export TF_WORKSPACE=$TWORKSPACE'
                sh 'terraform plan -var eks_name=$EKSCLUSTERNAME -var eksnode_name=$EKSNODENAME -var instance_types=$INSTANCETYPE -var vpc_cidr=$VPCCIDR -var public_subnets_cidr=$PUBLICSUBNETCIDR -var private_subnets_cidr=$PRIVATESUBNETCIDR -var workspace=$TWORKSPACE -var minnode=$MINNODE -var maxnode=$MAXNODE -var desirednode=$DESIREDNODE -out $TWORKSPACE.out'
                sh 'terraform show -no-color $TWORKSPACE.out > $TWORKSPACE.txt'
            }
        }
        stage('Apply the terraform code') {
            when {
                expression {
                    params.destroy==false
                }
            }
            steps {
                sh 'terraform apply $TWORKSPACE.out'
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
                sh 'terraform destroy $TWORKSPACE.out'
            }
        }
    }
}
