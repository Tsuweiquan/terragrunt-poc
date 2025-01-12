include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_parent_terragrunt_dir()}/modules/another_backend_module"
}

inputs = {
  # Environment-specific variables
}
