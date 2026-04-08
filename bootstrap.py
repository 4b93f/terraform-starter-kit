#!/usr/bin/env python3
import re
import sys
import boto3
from botocore.exceptions import ClientError, NoCredentialsError, EndpointResolutionError

VALID_REGIONS = [
    "us-east-1", "us-east-2", "us-west-1", "us-west-2",
    "eu-west-1", "eu-west-2", "eu-west-3", "eu-central-1", "eu-north-1",
    "ap-southeast-1", "ap-southeast-2", "ap-northeast-1", "ap-northeast-2",
    "ap-south-1", "sa-east-1", "ca-central-1", "af-south-1", "me-south-1",
]


def ask(prompt, default=None):
    suffix = f" [{default}]" if default else ""
    value = input(f"{prompt}{suffix}: ").strip()
    return value or default or ""


def validate_project_name(name):
    if not name:
        return "Project name cannot be empty."
    if not re.fullmatch(r"[a-z0-9-]+", name):
        return "Project name must only contain lowercase letters, numbers, and hyphens."
    if name.startswith("-") or name.endswith("-"):
        return "Project name cannot start or end with a hyphen."
    return None


def validate_region(region):
    if region not in VALID_REGIONS:
        return f"Invalid region '{region}'. Valid regions: {', '.join(VALID_REGIONS)}"
    return None


def create_state_bucket(s3, bucket_name, region):
    try:
        if region == "us-east-1":
            s3.create_bucket(Bucket=bucket_name)
        else:
            s3.create_bucket(
                Bucket=bucket_name,
                CreateBucketConfiguration={"LocationConstraint": region},
            )
        print(f"  Created S3 bucket: {bucket_name}")
    except ClientError as e:
        code = e.response["Error"]["Code"]
        if code == "BucketAlreadyOwnedByYou":
            print(f"  Bucket {bucket_name} already exists and is owned by you, skipping creation.")
        elif code == "BucketAlreadyExists":
            print(f"Error: Bucket '{bucket_name}' already exists and is owned by another account.")
            sys.exit(1)
        elif code == "AccessDenied":
            print(f"Error: Access denied. Check your AWS credentials and permissions.")
            sys.exit(1)
        else:
            print(f"Error creating bucket: {e}")
            sys.exit(1)


def enable_versioning(s3, bucket_name):
    try:
        s3.put_bucket_versioning(
            Bucket=bucket_name,
            VersioningConfiguration={"Status": "Enabled"},
        )
        print(f"  Enabled versioning on: {bucket_name}")
    except ClientError as e:
        print(f"Error enabling versioning: {e}")
        sys.exit(1)


def block_public_access(s3, bucket_name):
    try:
        s3.put_public_access_block(
            Bucket=bucket_name,
            PublicAccessBlockConfiguration={
                "BlockPublicAcls": True,
                "IgnorePublicAcls": True,
                "BlockPublicPolicy": True,
                "RestrictPublicBuckets": True,
            },
        )
        print(f"  Blocked public access on: {bucket_name}")
    except ClientError as e:
        print(f"Error blocking public access: {e}")
        sys.exit(1)


def print_backend_config(bucket_name, region):
    print("\n=== Add this to your environments/<stage>/provider.tf ===\n")
    print(f"""terraform {{
  backend "s3" {{
    bucket = "{bucket_name}"
    key    = "terraform.tfstate"
    region = "{region}"
  }}
}}""")
    print("\n=========================================================\n")


def main():
    print("=== Terraform Remote State Bootstrap ===\n")

    # Inputs
    while True:
        project_name = ask("Project name (lowercase, hyphens only)", default="my-project")
        error = validate_project_name(project_name)
        if not error:
            break
        print(f"  Error: {error}")

    while True:
        region = ask("AWS region", default="eu-west-1")
        error = validate_region(region)
        if not error:
            break
        print(f"  Error: {error}")

    bucket_name = f"{project_name}-terraform-state"

    print(f"\nWill create:")
    print(f"  S3 bucket : {bucket_name} (versioning + public access blocked)")
    print(f"  Region    : {region}\n")

    confirm = input("Proceed? [y/n]: ").strip().lower()
    if confirm != "y":
        print("Aborted.")
        sys.exit(0)

    print()

    # Create resources
    try:
        s3 = boto3.client("s3", region_name=region)
    except NoCredentialsError:
        print("Error: AWS credentials not found. Run 'aws configure' first.")
        sys.exit(1)

    try:
        create_state_bucket(s3, bucket_name, region)
        enable_versioning(s3, bucket_name)
        block_public_access(s3, bucket_name)
    except NoCredentialsError:
        print("Error: AWS credentials not found. Run 'aws configure' first.")
        sys.exit(1)
    except EndpointResolutionError:
        print("Error: Could not connect to AWS. Check your network and region.")
        sys.exit(1)

    print("\nBootstrap complete.")
    print_backend_config(bucket_name, region)


if __name__ == "__main__":
    main()
