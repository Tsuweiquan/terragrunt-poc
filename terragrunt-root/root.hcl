locals {
  path_components = compact(split("/", path_relative_to_include())) # take note this only works if u run in stack level or environment level
  path_region = local.path_components[1] # take note this only works if u run in stack level or environment level
  path_env = local.path_components[2]
  #################################################
  region_vars = read_terragrunt_config("${get_parent_terragrunt_dir()}/environments/${local.path_region}/region-env.hcl")
  env_vars = read_terragrunt_config("${get_parent_terragrunt_dir()}/environments/${local.path_region}/${local.path_env}/env.hcl")
  state_bucket_name = "207756197509-terragrunt-state"
  state_bucket_region = "ap-southeast-1"
  dynamodb_state_locking_table_name = "207756197509-terragrunt-state-locking"
  #################################################
  region = local.region_vars.locals.region
  aws_provider_version = local.env_vars.locals.aws_provider_version
  ################### DEBUG ########################
  debug_region_vars = run_cmd("echo", jsonencode(local.region_vars.locals))
  debug_env_vars = run_cmd("echo", jsonencode(local.env_vars.locals))
  dedbug_state_path = run_cmd("echo", jsonencode("${path_relative_to_include()}/terraform.tfstate"))
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
      version = "${local.aws_provider_version}"
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

# Merge Env and Region Global Variables
inputs = merge(local.region_vars.locals, local.env_vars.locals)