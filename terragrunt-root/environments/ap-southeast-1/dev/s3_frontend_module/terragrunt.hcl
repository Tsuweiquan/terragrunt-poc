include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/s3_frontend_module"
}

inputs = {
  # Environment-specific variables
}
