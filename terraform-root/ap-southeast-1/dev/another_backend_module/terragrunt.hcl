include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/another_backend_module"
}

inputs = {
  # Environment-specific variables
}
