variable "keypair" {
default="eks"
}
variable "keypair1" {
default="eks1"
}
variable "aws_region" {
default="us-east-2"
}
variable "publickey" {
default="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC9UpS02F4RjI4pa2nYNZ5vMwQwlVBO9VmFwuasn3b+0z/799X3P2Cbdl5peZ+YXiu0Gbsx0MjlzJUkQGC16sXvv0zxmSRZasziMdSKDzjn+NqVWjZeK4rZW9BOYT10YvMpn9lXl15LIdSKktN4reag67c1Su3F7oTPfM6nv21Pw7CH/RHBXlVB4drRwn6qOpHhiw2DEl8CMu0+2nWmy8Aci6W6RbWy029hvm/y6KWQHJclCnLMemM6x7O1vuonYGJRerY4+zSGwSJi9j8D7RQ2NgGv3MNCyRWW8zxwWvofkO54hQtjmfJ6lGb0QVZrMgUxSFTfFMshk7KjiA1kKPhDrAI9/JNlC1Fbml6Nh7SMlst/q+pkkvlNlttjcpHHigIybr4x46w+aKAm4nLFYNrx29pVl6hZDp5vPbyvP2RJPuiOOQGqy8SsGyHOZ67Zf58xkV9gJCHIRT7NhY+12srwfuFm8BDQjsqpYDxb4Lr0cce1O2BjETw+1s1u51k+Rw8= dhanabalan.r@VSPLBLRLT0317"
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