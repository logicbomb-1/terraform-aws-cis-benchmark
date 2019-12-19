data "aws_caller_identity" "current" {}

resource "aws_cloudwatch_log_group" "cloudwatch_log_group_ct" {
  name = var.cloudwatch_log_group_name
  retention_in_days = var.retention_days
}  


resource "aws_s3_bucket" "access_log" { 
  bucket = var.cloudtrail_bucket_log 
  #bucket = "a675c7cesslogbucket18"
  acl = "log-delivery-write"
  force_destroy = var.force_destroy

  lifecycle_rule {
    id = "log"
    enabled = true

    prefix="/"

    transition {
      days = var.log_transition_glacier_days
      storage_class = "GLACIER"
    }   
  }
} 


#resource "aws_s3_bucket" "cloudtrail_bucket" {
#  bucket = var.cloudtrail_bucket
#  versioning {
#    enabled = true
#  }            
#}  
#  logging {
#    target_bucket = "${aws_s3_bucket.access_log.id}"
#  }    
#
#  server_side_encryption_configuration {
#    rule {
#      apply_server_side_encryption_by_default {
#        sse_algorithm = "aws:kms"
#      }
#    }
#  }
#}
#
#resource "aws_s3_bucket_policy" "cloudtrail_bucket_policy" {
#  bucket = "${aws_s3_bucket.cloudtrail_bucket.id}"
#  depends_on = ["aws_s3_bucket.cloudtrail_bucket"]
#
#  policy = <<POLICY
#{
#    "Version": "2012-10-17",
#    "Statement": [
#        {
#            "Sid": "AWSCloudTrailAclCheck20150319",
#            "Effect": "Allow",
#            "Principal": {
#                "Service": "cloudtrail.amazonaws.com"
#            },
#            "Action": "s3:GetBucketAcl",
#            "Resource": "arn:aws:s3:::${var.cloudtrail_bucket}"
#        },
#        {
#            "Sid": "AWSCloudTrailWrite20150319",
#            "Effect": "Allow",
#            "Principal": {
#                "Service": "cloudtrail.amazonaws.com"
#            },
#            "Action": "s3:PutObject",
#            "Resource": "arn:aws:s3:::${var.cloudtrail_bucket}/AWSLogs/050634864816/*",
#            "Condition": {
#                "StringEquals": {
#                    "s3:x-amz-acl": "bucket-owner-full-control"
#                }
#            }
#        }
#    ]
#}  
#POLICY
#} 
#

resource "aws_cloudtrail" "cloudtrail_log" {
  name                          = "cloudtrail-log"
  s3_bucket_name                = "aws-test-account-cloudtrail1"
  #s3_bucket_name               = "${aws_s3_bucket.cloudtrail_bucket.id}"
  s3_key_prefix                 = "prefix"
  enable_logging                = true
  include_global_service_events = true
  enable_log_file_validation    = true
  is_multi_region_trail         = true
  cloud_watch_logs_group_arn    = "${aws_cloudwatch_log_group.cloudwatch_log_group_ct.arn}"
  cloud_watch_logs_role_arn     = "arn:aws:iam::050634864816:role/CloudTrail_CloudWatchLogs_Role"
  #cloud_watch_logs_role_arn     = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/CloudTrail_CloudWatchLogs_Role"
  #kms_key_id                   = var.kms_key_id
  #depends_on = ["aws_s3_bucket.cloudtrail_bucket"]
}
