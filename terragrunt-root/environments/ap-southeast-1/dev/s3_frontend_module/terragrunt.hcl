include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/modules/s3_frontend_module"
}

inputs = {
  # Environment-specific variables
}
