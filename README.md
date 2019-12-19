# terraform-aws-cis-benchmark

A terraform module to set up your AWS account with the reasonably secure configuration baseline. Most configurations are based on CIS Amazon Web Services Foundations v1.2.0.

See Benchmark Compliance to check which items in CIS benchmark are covered.

Starting from v0.10.0, this module requires Terraform v0.12 or later. Please use v0.9.0 if you need to use Terraform v0.11 or ealier.

# Features

## Identity and Access Management
1. Set up IAM Password Policy.
2. Create separated IAM roles for defining privileges and assigning them to entities such as IAM users and groups.
3. Create an IAM role for contacting AWS support for incident handling.
4. Enable AWS Config rules to audit root account status.

## Logging & Monitoring
1. Enable CloudTrail in all regions and deliver events to CloudWatch Logs.
2. CloudTrail logs are encrypted using AWS Key Management Service.
3. All logs are stored in the S3 bucket with access logging enabled.
4. Logs are automatically archived into Amazon Glacier after the given period(defaults to 90 days).
5. Set up CloudWatch alarms to notify you when critical changes happen in your AWS account.
6. Enable AWS Config in all regions to automatically take configuration snapshots.

## Networking
1. Enable AWS Config rules to audit unrestricted common ports in Security Group rules.
2. Enable VPC Flow Logs with the default VPC in all regions.
3. Enable GuardDuty in all regions.
 
Submodules
This module is composed of several submodules and each of which can be used independently. Modules in Package Sub-directories - Terraform describes how to source a submodule.

cloudtrail
cloudwatch_metric_alarm
guardduty
iam
elb_logging
vpc_flow
config
secure_s3

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please also consider contributing the dorks (githubtestdork.txt) that can reveal potentially sensitive information in github.
