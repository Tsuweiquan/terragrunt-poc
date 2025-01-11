locals {
  path_components = split("/", path_relative_to_include())
  region = local.path_components[1]
  env = local.path_components[2]
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = "207756197509-terragrunt-state"
    key    = "${path_relative_to_include()}/terraform.tfstate"
    region = "ap-southeast-1"
    encrypt = true
    dynamodb_table = "207756197509-terragrunt-state-locking"
  }
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


inputs = {
  region = local.region
  env = local.env
  region-suffix = local.region == "ap-southeast-1" ? "sg" : local.region == "ap-northeast-1" ? "tk" : ""
}
