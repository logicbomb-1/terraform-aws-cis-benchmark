resource "aws_cloudwatch_log_group" "vpc_flow_logs" {

  name              = var.vpc_log_group_name
  retention_in_days = var.vpc_log_retention_in_days
  tags = var.tags
}

resource "aws_flow_log" "vpc_flow_logs" {
  #for_each = var.vpc_ids1

  log_destination = aws_cloudwatch_log_group.vpc_flow_logs.arn
  iam_role_arn    = "${aws_iam_role.awsflowlogsrole.arn}"
  #vpc_id          = each.key 
  #count           = length(var.vpc_ids)
  vpc_id = var.vpc_ids
  #vpc_id          = var.vpc_ids[count.index]
  #vpc_id          = "vpc-0537a6a2f8e199e4c"   
  traffic_type    = "ALL"
  }    

resource "aws_iam_role" "awsflowlogsrole" {
  name = "awsflowlogsrole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "example" {
  name = "awsflowlogspolicy"
  role = "${aws_iam_role.awsflowlogsrole.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
