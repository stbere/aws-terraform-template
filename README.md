# aws-terraform-template
Terraform repository template for AWS

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
Default output format [None]:
```

# Usage

1. Bootstrap AWS using terraform using `make bootstrap`.

2. This will create a S3 bucket named `terraform-bucket-[DATE_SUFFIX]` and DynamoDb table named `teraform-state-lock`.


# Help

```
make help
```

# Contribution

Please create a PR if you want to contribute to this repository.