module "s3_wq_static_server_new" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.3.0"
  bucket  = "my-backend-server-file-storage-${var.env}-${var.region-suffix}"
  acl     = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  versioning = {
    enabled = true
  }
}
