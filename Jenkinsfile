pipeline {
    agent any
    parameters {
        string(name: 'EKSCLUSTERNAME', defaultValue: 'ekscluster', description: 'Enter Name for EKS Cluster')
        string(name: 'EKSNODENAME', defaultValue: 'eksnode', description: 'Enter name for EKS node group')
        string(name: 'TWORKSPACE', defaultValue: 'default', description: 'Enter Terraform workspace name')
        string(name: 'INSTANCETYPE', defaultValue: '["t3.medium"]', description: 'Enter Instance type')
        booleanParam(name: 'destroy', defaultValue: true, description: 'Select the checkbox if you want to destroy the infrastructure')
        booleanParam(name: 'existingvpc', defaultValue: true, description: 'Select the checkbox if you want to use existing vpc')
        string(name: 'VPCCIDR', defaultValue: '10.0.0.0/20', description: 'Enter CIDR in case of creating new VPC')
        text(name: 'PRIVATESUBNETCIDR', defaultValue: '["10.0.2.0/24","10.0.3.0/24","10.0.4.0/24"]', description: 'Enter CIDR for three private subnet')
        text(name: 'EXISTINGSUBNETS', defaultValue: '["subnet-0024c97d","subnet-2fe2b763","subnet-98bd0af3"]', description: 'Enter existing subnet ID')
        string(name: 'PUBLICSUBNETCIDR', defaultValue: '["10.0.5.0/24","10.0.6.0/24","10.0.7.0/24"]', description: 'Enter CIDR for public subnet')
        string(name: 'MINNODE', defaultValue: '2', description: 'Enter minimum node count for EKS cluster')
        string(name: 'MAXNODE', defaultValue: '4', description: 'Enter maximum node count for EKS cluster')
        string(name: 'DESIREDNODE', defaultValue: '2', description: 'Enter desired node count for EKS cluster')
    }
    stages {
        stage('Git checkout') { 
            steps {
                sh 'whoami'
                git branch: 'master', credentialsId: '6558272a-3027-44cb-8bfc-a25b9cab9f45', url: 'https://github.com/Dhanabalan-pop/EKS.git'
            }
        }
        stage('Terraform Initialization') { 
                when {
                expression {
                    params.destroy==false
                }
            }
            steps {
                    sh 'terraform init'
                    sh 'terraform workspace select $TWORKSPACE || terraform workspace new $TWORKSPACE'
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
                sh 'terraform plan -var existingvpc=$existingvpc -var existingsubnets=$EXISTINGSUBNETS -var eks_name=$EKSCLUSTERNAME -var eksnode_name=$EKSNODENAME -var instance_types=$INSTANCETYPE -var vpc_cidr=$VPCCIDR -var public_subnets_cidr=$PUBLICSUBNETCIDR -var private_subnets_cidr=$PRIVATESUBNETCIDR -var workspace=$TWORKSPACE -var minnode=$MINNODE -var maxnode=$MAXNODE -var desirednode=$DESIREDNODE -out $TWORKSPACE.out'
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
        stage('Run Kubectl and Helm scripts') {
            when {
                expression {
                    params.destroy==false
                }
            }
            environment {
          EKSNAME = sh (script: 'terraform output EKSclustername',returnStdout: true).trim()
        }
            steps {
                sh 'echo $EKSNAME'
                sh 'whoami'
                sh 'sudo bash scripts/kubectl.sh $EKSNAME'
                sh 'sudo bash scripts/helm.sh'
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
