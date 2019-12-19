resource "aws_config_config_rule" "cloud-trail-encryption-enabled" {
  name = "cloud-trail-encryption-enabled"
  source {
    owner             = "AWS"
    source_identifier = "CLOUD_TRAIL_ENCRYPTION_ENABLED"
  }

  depends_on = ["aws_config_configuration_recorder.config_record"]
}


module "secure_s3_bucket" {
    source = "../secure_s3"
    force_destroy = true
    tag_bucket_name = var.tag_bucket_name
    tag_bucket_env = var.tag_bucket_env
    log_transition_glacier_days = var.log_transition_glacier_days
    user_bucket_name = var.user_bucket_name
}

resource "aws_config_configuration_recorder" "config_record" {
  name     = "configuration-record"
  role_arn = "${aws_iam_role.r.arn}"
}

resource "aws_config_delivery_channel" "channel" {
  name           = "example"
  s3_bucket_name = "${module.secure_s3_bucket.s3_bucket_id}"
  depends_on     = ["aws_config_configuration_recorder.config_record"]
}



resource "aws_iam_role" "r" {
  name = "my-awsconfig-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "config.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy" "p" {
  name = "my-awsconfig-policy"
  role = "${aws_iam_role.r.id}"

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "*",
            "Resource": "*"
        }
    ]
}  
POLICY
}
