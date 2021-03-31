pipeline {
    agent any
    parameters {
        string(name: 'EKSCLUSTERNAME', defaultValue: 'ekscluster', description: 'Enter Name for EKS Cluster')
        string(name: 'EKSNODENAME', defaultValue: 'eksnode', description: 'Enter name for EKS node group')
        string(name: 'TWORKSPACE', defaultValue: 'default', description: 'Enter Terraform workspace name')
        string(name: 'INSTANCETYPE', defaultValue: '["t3.medium"]', description: 'Enter Instance type')
        booleanParam(name: 'destroy', defaultValue: true, description: 'Select the checkbox if you want to destroy the infrastructure')
        booleanParam(name: 'existingvpc', defaultValue: true, description: 'Select the checkbox if you want to use existing vpc')
        text(name: 'EXISTINGSUBNETS', defaultValue: '["subnet-0024c97d","subnet-2fe2b763","subnet-98bd0af3"]', description: 'Enter existing subnet ID,3subnet is required')
        string(name: 'VPCCIDR', defaultValue: '0.0.0.0/0', description: 'Enter CIDR in case of creating new VPC')
        text(name: 'PRIVATESUBNETCIDR', defaultValue: '["0.0.0.0/0","0.0.0.0/0","0.0.0.0/0"]', description: 'Enter CIDR for three private subnet')
        string(name: 'PUBLICSUBNETCIDR', defaultValue: '0.0.0.0/0', description: 'Enter CIDR for public subnet')
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
                sh 'terraform plan -var eks_name=$EKSCLUSTERNAME -var eksnode_name=$EKSNODENAME -var instance_types=$INSTANCETYPE -var existingvpc=$existingvpc -var existingsubnets=$EXISTINGSUBNETS -var vpc_cidr=$VPCCIDR -var public_subnets_cidr=$PUBLICSUBNETCIDR -var private_subnets_cidr=$PRIVATESUBNETCIDR -out $TWORKSPACE.out'
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
                sh 'terraform destroy -auto-approve'
            }
        }
    }
}
