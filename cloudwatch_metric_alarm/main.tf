resource "aws_sns_topic" "alarms" {
  name              = var.sns_name
  kms_master_key_id = "alias/aws/sns"
}

resource "aws_cloudwatch_log_group" "cloudwatch_log_group" {
  name = var.cloudwatch_log_group_name
  retention_in_days = var.retention_days
}

resource "aws_cloudwatch_log_metric_filter" "unauthorized_api_calls" {
  name = "unathorizedApiCalls"
  pattern = "{ ($.errorCode = \"*UnauthorizedOperation\") || ($.errorCode = \"AccessDenied*\") }"
  log_group_name = "${aws_cloudwatch_log_group.cloudwatch_log_group.id}"

  metric_transformation {
    name = "EventCount"
    namespace = var.alarm_namespace
    value = "1"
  }
}  


resource "aws_cloudwatch_metric_alarm" "unauthorized_api_calls" {

  alarm_name                = "UnauthorizedAPICalls"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = aws_cloudwatch_log_metric_filter.unauthorized_api_calls.id
  namespace                 = var.alarm_namespace
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Monitoring unauthorized API calls will help reveal application errors and may reduce time to detect malicious activity."
  alarm_actions             = ["${aws_sns_topic.alarms.arn}"]
  treat_missing_data        = "notBreaching"
}


resource "aws_cloudwatch_log_metric_filter" "console_login" {
  name = "consoleLoginCalls"
  pattern = "{ ($.eventName = \"ConsoleLogin\") && ($.additionalEventData.MFAUsed != \"Yes\") }"
  log_group_name = "${aws_cloudwatch_log_group.cloudwatch_log_group.id}"

  metric_transformation {
    name = "EventCount"
    namespace = var.cloudwatch_namespace
    value = "1" 
  }
} 


resource "aws_cloudwatch_metric_alarm" "console_login" {
  
  alarm_name                = "UnauthorizedAPICalls"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = aws_cloudwatch_log_metric_filter.console_login.id
  namespace                 = var.alarm_namespace
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Monitoring unauthorized API calls will help reveal application errors and may reduce time to detect malicious activity."                                                            
  alarm_actions             = [aws_sns_topic.alarms.arn]
  treat_missing_data        = "notBreaching"
}


resource "aws_cloudwatch_log_metric_filter" "root_account_use" {
  name = "rootAccountUse"
  pattern =  "{ $.userIdentity.type = \"Root\" && $.userIdentity.invokedBy NOT EXISTS && $.eventType != \"AwsServiceEvent\" }"
  log_group_name = "${aws_cloudwatch_log_group.cloudwatch_log_group.id}"

  metric_transformation {
    name = "EventCount"
    namespace = var.cloudwatch_namespace
    value = "1" 
  }
} 

resource "aws_cloudwatch_metric_alarm" "root_account_use" {
  
  alarm_name                = "UnauthorizedAPICalls"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = aws_cloudwatch_log_metric_filter.root_account_use.id
  namespace                 = var.alarm_namespace
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Monitoring unauthorized API calls will help reveal application errors and may reduce time to detect malicious activity."                                                            
  alarm_actions             = [aws_sns_topic.alarms.arn]
  treat_missing_data        = "notBreaching"
}

resource "aws_cloudwatch_log_metric_filter" "iam_policy_change" {
  name = "iamPolicyChange"
  pattern = "{($.eventName=DeleteGroupPolicy)||($.eventName=DeleteRolePolicy)||($.eventName=DeleteUserPolicy)||($.eventName=PutGroupPolicy)||($.eventName=PutRolePolicy)||($.eventName=PutUserPolicy)||($.eventName=CreatePolicy)||($.eventName=DeletePolicy)||($.eventName=CreatePolicyVersion)||($.eventName=DeletePolicyVersion)||($.eventName=AttachRolePolicy)||($.eventName=DetachRolePolicy)||($.eventName=AttachUserPolicy)||($.eventName=DetachUserPolicy)||($.eventName=AttachGroupPolicy)||($.eventName=DetachGroupPolicy)}"
  log_group_name = "${aws_cloudwatch_log_group.cloudwatch_log_group.id}"

  metric_transformation {
    name = "EventCount"
    namespace = var.cloudwatch_namespace
    value = "1" 
  }
} 


resource "aws_cloudwatch_metric_alarm" "iam_policy_change" {

  alarm_name                = "UnauthorizedAPICalls"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = aws_cloudwatch_log_metric_filter.iam_policy_change.id
  namespace                 = var.alarm_namespace
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Monitoring unauthorized API calls will help reveal application errors and may reduce time to detect malicious activity."
  alarm_actions             = [aws_sns_topic.alarms.arn]
  treat_missing_data        = "notBreaching"
}


resource "aws_cloudwatch_log_metric_filter" "cloudtrail_change" {
  name = "cloudtrailChange"
  pattern = "{ ($.eventName = CreateTrail) || ($.eventName =UpdateTrail) || ($.eventName = DeleteTrail) || ($.eventName = StartLogging)|| ($.eventName = StopLogging) }"
  log_group_name = "${aws_cloudwatch_log_group.cloudwatch_log_group.id}"

  metric_transformation {
    name = "EventCount"
    namespace = var.cloudwatch_namespace
    value = "1" 
  }
} 


resource "aws_cloudwatch_metric_alarm" "cloudtrail_change" {
  
  alarm_name                = "UnauthorizedAPICalls"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = aws_cloudwatch_log_metric_filter.cloudtrail_change.id
  namespace                 = var.alarm_namespace
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Monitoring unauthorized API calls will help reveal application errors and may reduce time to detect malicious activity."                                                            
  alarm_actions             = [aws_sns_topic.alarms.arn]
  treat_missing_data        = "notBreaching"
}


resource "aws_cloudwatch_log_metric_filter" "auth_fail" {
  name = "authFail"
  pattern = "{ ($.eventName = ConsoleLogin) && ($.errorMessage = \"Failedauthentication\") }"
  log_group_name = "${aws_cloudwatch_log_group.cloudwatch_log_group.id}"

  metric_transformation {
    name = "EventCount"
    namespace = var.cloudwatch_namespace
    value = "1" 
  }
}


resource "aws_cloudwatch_metric_alarm" "auth_fail" {

  alarm_name                = "UnauthorizedAPICalls"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = aws_cloudwatch_log_metric_filter.auth_fail.id
  namespace                 = var.alarm_namespace
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Monitoring unauthorized API calls will help reveal application errors and may reduce time to detect malicious activity."
  alarm_actions             = [aws_sns_topic.alarms.arn]
  treat_missing_data        = "notBreaching"
}



resource "aws_cloudwatch_log_metric_filter" "disable_cmk" {
  name = "disableCmk"
  pattern = "{($.eventSource = kms.amazonaws.com) &&(($.eventName=DisableKey)||($.eventName=ScheduleKeyDeletion)) }" 
  log_group_name = "${aws_cloudwatch_log_group.cloudwatch_log_group.id}"

  metric_transformation {
    name = "EventCount"
    namespace = var.cloudwatch_namespace
    value = "1" 
  }
}


resource "aws_cloudwatch_metric_alarm" "disable_cmk" {

  alarm_name                = "UnauthorizedAPICalls"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = aws_cloudwatch_log_metric_filter.disable_cmk.id
  namespace                 = var.alarm_namespace
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Monitoring unauthorized API calls will help reveal application errors and may reduce time to detect malicious activity."
  alarm_actions             = [aws_sns_topic.alarms.arn]
  treat_missing_data        = "notBreaching"
}



resource "aws_cloudwatch_log_metric_filter" "s3_policy_change" {
  name = "s3PolicyChange"
  pattern = "{ ($.eventSource = s3.amazonaws.com) && (($.eventName =PutBucketAcl) || ($.eventName = PutBucketPolicy) || ($.eventName =PutBucketCors) || ($.eventName = PutBucketLifecycle) || ($.eventName =PutBucketReplication) || ($.eventName = DeleteBucketPolicy) || ($.eventName =DeleteBucketCors) || ($.eventName = DeleteBucketLifecycle) || ($.eventName =DeleteBucketReplication)) }"
  log_group_name = "${aws_cloudwatch_log_group.cloudwatch_log_group.id}"

  metric_transformation {
    name = "EventCount"
    namespace = var.cloudwatch_namespace
    value = "1" 
  }
}

resource "aws_cloudwatch_metric_alarm" "s3_policy_change" {
  
  alarm_name                = "UnauthorizedAPICalls"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = aws_cloudwatch_log_metric_filter.s3_policy_change.id
  namespace                 = var.alarm_namespace
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Monitoring unauthorized API calls will help reveal application errors and may reduce time to detect malicious activity."                                                            
  alarm_actions             = [aws_sns_topic.alarms.arn]
  treat_missing_data        = "notBreaching"
}


resource "aws_cloudwatch_log_metric_filter" "aws_config_change" {
  name = "awsConfigChange"
  pattern = "{ ($.eventSource = config.amazonaws.com) &&(($.eventName=StopConfigurationRecorder)||($.eventName=DeleteDeliveryChannel)||($.eventName=PutDeliveryChannel)||($.eventName=PutConfigurationRecorder))}"
  log_group_name = "${aws_cloudwatch_log_group.cloudwatch_log_group.id}"

  metric_transformation {
    name = "EventCount"
    namespace = var.cloudwatch_namespace
    value = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "aws_config_change" {
  
  alarm_name                = "UnauthorizedAPICalls"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = aws_cloudwatch_log_metric_filter.aws_config_change.id
  namespace                 = var.alarm_namespace
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Monitoring unauthorized API calls will help reveal application errors and may reduce time to detect malicious activity."                                                            
  alarm_actions             = [aws_sns_topic.alarms.arn]
  treat_missing_data        = "notBreaching"
}


resource "aws_cloudwatch_log_metric_filter" "sg_change" {
  name = "sgChange"
  pattern = "{($.eventName = AuthorizeSecurityGroupIngress) || ($.eventName =AuthorizeSecurityGroupEgress) || ($.eventName = RevokeSecurityGroupIngress)|| ($.eventName = RevokeSecurityGroupEgress) || ($.eventName =CreateSecurityGroup) || ($.eventName = DeleteSecurityGroup)}"
  log_group_name = "${aws_cloudwatch_log_group.cloudwatch_log_group.id}"

  metric_transformation {
    name = "EventCount"
    namespace = var.cloudwatch_namespace
    value = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "sg_change" {
  
  alarm_name                = "UnauthorizedAPICalls"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = aws_cloudwatch_log_metric_filter.sg_change.id
  namespace                 = var.alarm_namespace
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Monitoring unauthorized API calls will help reveal application errors and may reduce time to detect malicious activity."                                                            
  alarm_actions             = [aws_sns_topic.alarms.arn]
  treat_missing_data        = "notBreaching"
}



resource "aws_cloudwatch_log_metric_filter" "acl_change" {
  name = "aclChange"
  pattern = "{ ($.eventName = CreateNetworkAcl) || ($.eventName =CreateNetworkAclEntry) || ($.eventName = DeleteNetworkAcl) || ($.eventName =DeleteNetworkAclEntry) || ($.eventName = ReplaceNetworkAclEntry) ||($.eventName = ReplaceNetworkAclAssociation) }"
  log_group_name = "${aws_cloudwatch_log_group.cloudwatch_log_group.id}"
  metric_transformation {
    name = "EventCount"
    namespace = var.cloudwatch_namespace
    value = "1"
  }
}


resource "aws_cloudwatch_metric_alarm" "acl_change" {

  alarm_name                = "UnauthorizedAPICalls"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = aws_cloudwatch_log_metric_filter.acl_change.id
  namespace                 = var.alarm_namespace
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Monitoring unauthorized API calls will help reveal application errors and may reduce time to detect malicious activity."
  alarm_actions             = [aws_sns_topic.alarms.arn]
  treat_missing_data        = "notBreaching"
}


resource "aws_cloudwatch_log_metric_filter" "route_table_change" {
  name = "rtChange"
  pattern = "{ ($.eventName = CreateRoute) || ($.eventName =CreateRouteTable) || ($.eventName = ReplaceRoute) || ($.eventName =ReplaceRouteTableAssociation) || ($.eventName = DeleteRouteTable) ||($.eventName = DeleteRoute) || ($.eventName = DisassociateRouteTable) }"
  log_group_name = "${aws_cloudwatch_log_group.cloudwatch_log_group.id}"

  metric_transformation {
    name = "EventCount"
    namespace = var.cloudwatch_namespace
    value = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "route_table_change" {
  
  alarm_name                = "UnauthorizedAPICalls"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = aws_cloudwatch_log_metric_filter.route_table_change.id
  namespace                 = var.alarm_namespace
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Monitoring unauthorized API calls will help reveal application errors and may reduce time to detect malicious activity."                                                        
  alarm_actions             = [aws_sns_topic.alarms.arn]
  treat_missing_data        = "notBreaching"
}
