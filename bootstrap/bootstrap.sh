#!/usr/env/bin bash
# shellcheck shell=bash


set -o errexit
set -o pipefail

# Globals
CURRENT_DATE=$(date '+%Y-%m-%d')

error(){
    echo "ERROR: $*" >&2
}

info(){
    echo "INFO: $*" >&2
}

debug(){
    if $DEBUG; then
        echo "DEBUG: $*" >&2
    fi
}

usage(){
    cat <<EOF

Script for bootstrapping aws to make it ready to be managed by terraform.

Usage: ${0##*/} [-b bucket_name] [-e environment] [-r region] [-d dynamodb_name]

Options:
    -b <bucket_name>            Specify name for the S3 Bucket
    -e environment              Speficy the environment
    -r region                   Specify which AWS region to create the bucket
    -d dynamodb_name            Specify name for the DynamoDB table

Example usage:

    ${0##*/} -b terraform-bucket -e dev -r us-west-1 -d terraform-state-file

EOF
}

while getopts ":b:e:r:d:" options; do
    case "$options" in
        b)
            BUCKET_NAME=$OPTARG
            ;;
        e)
            ENVIRONMENT=$OPTARG
            ;;
        r)
            REGION=$OPTARG
            ;;
        d)
            DYNAMO_DB=$OPTARG
            ;;
        *)
            error "Unknown flag"
            usage
            exit 1
            ;;
    esac
done


if [ -z "$BUCKET_NAME" ]; then
    error "You need to specify bucket name using -b"
    usage
    exit 1
fi

if [ -z "$ENVIRONMENT" ]; then
    error "You need to specify environment name using -e"
    usage
    exit 1
fi

if [ -z "$REGION" ]; then
    error "You need to specify region name using -r"
    usage
    exit 1
fi

if [ -z "$DYNAMO_DB" ]; then
    error "You need to specify dynamo db name using -d"
    usage
    exit 1
fi

check_bucket_already_exists(){
    local response
    local bucket_name=$1
    response=$(aws s3 ls --profile "$ENVIRONMENT" | awk 'FS=" " {print $3}')
    if [[ $response -eq $bucket_name ]]; then
        echo "exists"
    fi
}

check_table_exists(){
    local response
    local dynamo_db_table=$1
    local region=$2
    local profile=$3
    response=$(aws dynamodb list-tables --profile $profile \
                                        --region $region | jq '.TableNames[] | select("aws-terraform--state-live-lock")' | tr -d \")
    if [[ "$response" == "$dynamo_db_table" ]]; then
        echo "exists"
    else
        echo "does not exists"
    fi
}

create_s3_bucket(){
    local response
    response=$(aws s3api create-bucket \
                --bucket $BUCKET_NAME \
                --region $REGION \
                --profile $ENVIRONMENT)
    echo "$response"
}

create_dynamo_db_table(){
    local response
    local dynamo_db_table=$1
    local region=$2
    local profile=$3
    response=$(aws dynamodb create-table \
                --table-name $dynamo_db_table \
                --key-schema AttributeName=LockID,KeyType=HASH \
                --region $region \
                --profile $profile \
                --attribute-definitions AttributeName=LockID,AttributeType=S \
                --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
                --tags Key=env,Value=$profile)
    echo "$response"
}

enable_bucket_versioning(){
    local bucket_name=$1
    local environment=$2
    info "Enable versioning on $1"
    aws s3api put-bucket-versioning --bucket $bucket_name \
                                    --versioning-configuration Status=Enabled \
                                    --profile $environment
}

main(){
    local ret

    info "Checking if bucket already exists."
    ret=$(check_bucket_already_exists "$BUCKET_NAME" "$ENVIRONMENT")
    if [[ $ret = "exists" ]]; then
        info "Bucket already exists. Moving on"
    else
        create_s3_bucket "$BUCKET_NAME" "$REGION" "$ENVIRONMENT"
    fi

    # TODO: Check if bucket versioning has already been enabled
    enable_bucket_versioning "$BUCKET_NAME" "$ENVIRONMENT"


    info "Checking if dynamodb table already exists."
    ret=$(check_table_exists "$DYNAMO_DB" "$REGION" "$ENVIRONMENT" )
    if [[ $ret = "exists" ]]; then
        info "DynamoDB Table already exists. Moving on"
    else
        create_dynamo_db_table "$DYNAMO_DB" "$REGION" "$ENVIRONMENT"
    fi

}

main "$@"

