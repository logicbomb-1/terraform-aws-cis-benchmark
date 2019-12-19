resource "aws_s3_bucket" "access_log" {
  bucket = "access1logbucket"
  acl = "log-delivery-write"
  force_destroy = var.force_destroy

  lifecycle_rule {
    id = "log"
    enabled = true

    prefix="log/"

    transition  {
      days = var.log_transition_glacier_days
      storage_class = "GLACIER"
    }
  }
} 

resource "aws_s3_bucket" "user_bucket" {
  bucket = var.user_bucket_name
  acl = "private"

  tags = {
    Name = var.tag_bucket_name
    Environment = var.tag_bucket_env
  }

  versioning {
    enabled = true
  }

  logging {
    target_bucket = "${aws_s3_bucket.access_log.id}"
  }

  server_side_encryption_configuration  {
    rule  {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
      }
    }
  }
} 

resource "aws_s3_bucket_public_access_block" "bucket_public_blocking" {
  bucket = "${aws_s3_bucket.user_bucket.id}"

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}  
