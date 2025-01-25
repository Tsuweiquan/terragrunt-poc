include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../stacks/another_backend_stack"
}

inputs = {
  # Environment-specific variables
}
