variable "key_name" {
default="eks1"
}
variable "workspace" {
default="default"
}
variable "aws_region" {
default="us-east-2"
}
variable "eksclusterrole" {
default="eksclusterrole"
}
variable "eksnoderole" {
default="eksnoderole"
}
variable "policy_arn1"{
default="arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}
variable "policy_arn2"{
default="arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}
variable "policy_arn3"{
default="arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}
variable "policy_arn4"{
default="arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}
variable "policy_arn5"{
default="arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}
variable "role"{
    default=<<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}
variable "role1"{
    default=<<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}
//Networking
variable "vpc_cidr" {
  description = "The CIDR block of the vpc"
  default = "10.0.0.0/20"
}

variable "public_subnets_cidr" {
  type        = string
  description = "The CIDR block for the public subnet"
  default="10.0.5.0/24"
}

variable "private_subnets_cidr" {
  type        = list
  description = "The CIDR block for the private subnet"
  default=["10.0.2.0/24","10.0.3.0/24","10.0.4.0/24"]
}
variable "vpc_name"{
  type = string
  description = "Enter the name for your VPC"
  default="myvpc"

}
variable "ig_name"{
  type = string
  description = "Enter the name for your Internet Gateway"
  default="my-ig"

}
variable "publicsubnet_name"{
  type = string
  description = "Enter the name for your public subnet"
  default="mypublicsubnet"
}
variable "nat_name"{
  type = string
  description = "Enter the name for your NAT Gateway"
  default="my-nat-gateway-01"

}
variable "routetable_name"{
  type = string
  description = "Enter the name for your route table"
  default="myroutetable"
}
variable "eks_name"{
  type = string
  description = "Enter the name for your EKS cluster"
  default="myekscluster"
}
variable "eksnode_name"{
  type=string
  description= "Enter name for EKS node group"
  default="myeksnodegroup"
}
variable "instance_types"{
  type=list(string)
  description="Enter instance type"
  default=["t3.medium"]
}
variable "existingvpc"{
  type=string
  description="Specify true if you want to use existing VPC"
  default="true"
}
variable "existingsubnets" {
  type        = list
  description = "Enter ID for the private subnet"
  default=["subnet-0024c97d","subnet-2fe2b763","subnet-98bd0af3"]
}
variable "minnode"{
  type=string
  description="Enter Min node count for EKS cluster"
  default="1"
}
variable "maxnode"{
  type=string
  description="Enter Max node count for EKS cluster"
  default="2"
}
variable "desirednode"{
  type=string
  description="Enter desired node count for EKS cluster"
  default="2"
}