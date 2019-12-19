variable "force_destroy" {
  type = (bool)
  default = true
}

variable "log_transition_glacier_days" {
  type = (number)
  default = 1800
}  

variable "kms_key_id" {
  type = (string)
}  

variable "cloudtrail_bucket_log" {
  type = (string)
  default = "cloudtrailbucketlogun1"
}

variable "cloudtrail_bucket" {
  type = (string)
  default = "cloudtrailbucketun1"
}


variable "retention_days" {
  type = (string)
  default = "180"
}

variable "cloudwatch_log_group_name" {
  type = (string)
  default = "cloudtrailbucketcw"
}
