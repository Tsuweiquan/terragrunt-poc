locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region = "ap-southeast-1"
  state_bucket_name = "207756197509-terragrunt-state"
  state_bucket_region = "ap-southeast-1"
  dynamodb_state_locking_table_name = "207756197509-terragrunt-state-locking"
}

# Generated backend block
remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = local.state_bucket_name
    key    = "${path_relative_to_include()}/terraform.tfstate"
    region = local.state_bucket_region
    encrypt = true
    dynamodb_table = local.dynamodb_state_locking_table_name
  }
}

# Generate a required provider block
generate "required_provider" {
  path      = "required_provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "${local.env_vars.locals.aws_provider_version}"
    }
  }
}
EOF
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.region}"
}
EOF
}

# Global Variables across region and environment
inputs = {

}
