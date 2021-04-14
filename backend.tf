terraform {
required_version = "~> 0.13"
backend "s3" {
bucket               = "awsbucket-terraformstate-uswest"
region               = "us-west-1"
key                  = "backend.tfstate"
workspace_key_prefix = "main"
dynamodb_table       = "terraform-state-dynamodb"
}
}
