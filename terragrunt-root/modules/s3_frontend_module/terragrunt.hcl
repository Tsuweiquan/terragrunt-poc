include "root" {
  path = find_in_parent_folders("root.hcl")
}

# Dependency on another stack/module.
dependency "depend_on_another_backend_module" {
  config_path = "../another_backend_module"
  # Can also use mock data here to do testing!
  mock_outputs = {
    another_backend_module_s3_bucket_name = "this_is_a_mock_s3_bucket_name"
  }
}

inputs = {
  # Environment-specific variables
  another_backend_s3_bucket_name = dependency.depend_on_another_backend_module.outputs.another_backend_module_s3_bucket_name
}
