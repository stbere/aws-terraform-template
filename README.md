# aws-terraform-template

Base template repository for provisioning resources in AWS using Terraform.

# Help

```
% make help

audit                          Audits terraform code against any security issues
bootstrap                      Bootstrapping AWS to be managed using Terraform
fmt                            Formats terraform code
help                           List targets & descriptions
init                           Clean initialisation of terraform against backend s3 bucket
lint                           Runs terraform linter against the code
```

## Requirement

You should have already created AWS IAM user and credentials showld already be stored in `~/.aws/credentials`.

eg

```
% cat ~/.aws/credentials

[dev]
aws_access_key_id = AKIATXXXXXXXXXXXXXX
aws_secret_access_key = LNouXXXXXXXXXXXXX
```

If you have not configured the account, you can do using
```
% aws configure

AWS Access Key ID [None]: <copy paste from aws console>
AWS Secret Access Key [None]: <copy paste from aws console>
Default region name [None]: prod
Default output format [None]: json
```

# Usage

1. Bootstrap AWS using terraform using `make bootstrap`.

2. This will create a S3 bucket named `aws-terraform-s3-bucket` and DynamoDb table named `aws-terraform--state-live-lock` in region `us-east-1`.

3. Verify bucket and dynamodb table is created via AWS console.

4. Once verified run `make init`. This will intitialise your terraform code using remote s3 as backend and dynamoDB for locks storage.



# Formatting terraform code
```
terraform fmt -recursive
```



# Contribution

Please create a PR if you want to contribute to this repository.