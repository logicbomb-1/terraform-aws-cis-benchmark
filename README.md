# terraform-aws-cis-benchmark

A terraform module to set up your AWS account with the reasonably secure configuration baseline. Most configurations are based on CIS Amazon Web Services Foundations v1.2.0.

See Benchmark Compliance to check which items in CIS benchmark are covered.

Starting from v0.10.0, this module requires Terraform v0.12 or later. Please use v0.9.0 if you need to use Terraform v0.11 or ealier.

*Features*
Identity and Access Management
Set up IAM Password Policy.
Create separated IAM roles for defining privileges and assigning them to entities such as IAM users and groups.
Create an IAM role for contacting AWS support for incident handling.
Enable AWS Config rules to audit root account status.
Logging & Monitoring
Enable CloudTrail in all regions and deliver events to CloudWatch Logs.
CloudTrail logs are encrypted using AWS Key Management Service.
All logs are stored in the S3 bucket with access logging enabled.
Logs are automatically archived into Amazon Glacier after the given period(defaults to 90 days).
Set up CloudWatch alarms to notify you when critical changes happen in your AWS account.
Enable AWS Config in all regions to automatically take configuration snapshots.
Enable SecurityHub and subscribe CIS benchmark standard.
Networking
Remove all rules associated with default route tables, default network ACLs and default security groups in the default VPC in all regions.
Enable AWS Config rules to audit unrestricted common ports in Security Group rules.
Enable VPC Flow Logs with the default VPC in all regions.
Enable GuardDuty in all regions.
Usage
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

module "secure_baseline" {
  source  = "nozaq/secure-baseline/aws"

  audit_log_bucket_name           = "YOUR_BUCKET_NAME"
  aws_account_id                  = data.aws_caller_identity.current.account_id
  region                          = data.aws_region.current.name
  support_iam_role_principal_arns = ["YOUR_IAM_USER"]

  providers = {
    aws                = aws
    aws.ap-northeast-1 = aws.ap-northeast-1
    aws.ap-northeast-2 = aws.ap-northeast-2
    aws.ap-south-1     = aws.ap-south-1
    aws.ap-southeast-1 = aws.ap-southeast-1
    aws.ap-southeast-2 = aws.ap-southeast-2
    aws.ca-central-1   = aws.ca-central-1
    aws.eu-central-1   = aws.eu-central-1
    aws.eu-north-1     = aws.eu-north-1
    aws.eu-west-1      = aws.eu-west-1
    aws.eu-west-2      = aws.eu-west-2
    aws.eu-west-3      = aws.eu-west-3
    aws.sa-east-1      = aws.sa-east-1
    aws.us-east-1      = aws.us-east-1
    aws.us-east-2      = aws.us-east-2
    aws.us-west-1      = aws.us-west-1
    aws.us-west-2      = aws.us-west-2
  }
}
Check the example to understand how these providers are defined. Note that you need to define a provider for each AWS region and pass them to the module. Currently this is the recommended way to handle multiple regions in one module. Detailed information can be found at Providers within Modules - Terraform Docs.

A new S3 bucket to store audit logs is automatically created by default, while the external S3 bucket can be specified. It is useful when you already have a centralized S3 bucket to store all logs. Please see external-bucket example for more detail.

Managing multiple accounts in AWS Organization
When you have multiple AWS accounts in your AWS Organization, secure-baseline module configures the separated environment for each AWS account. You can change this behavior to centrally manage security information and audit logs from all accounts in one master account. Check organization example for more detail.

Submodules
This module is composed of several submodules and each of which can be used independently. Modules in Package Sub-directories - Terraform describes how to source a submodule.

alarm-baseline
cloudtrail-baseline
guardduty-baseline
iam-baseline
vpc-baseline
secure-bucket
```

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please also consider contributing the dorks (githubtestdork.txt) that can reveal potentially sensitive information in github.
