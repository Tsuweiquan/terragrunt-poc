include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../stacks/s3_frontend_stack"
}

inputs = {
  # Environment-specific variables
}
