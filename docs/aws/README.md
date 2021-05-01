Templates for the json files mentioned in this documentation are saved in this directory of the repo.

1. Install awscli
    - On mac:
    ```bash
    brew install awscli
    ```
    - On OpenBSD:
    ```bash
    pkg_add awscli
    ```

2. Create a new IAM account just for administering this lappland-santa server in the AWS console.

3. Set some environment variables to save a little typing later:
```bash
export PROFILE=lappland-santa-$(date +"%Y-%m-%d")
export REGION=your-region-(e.g. us-east-2)
export BUCKET=your-bucket-name
```
4. Create a configuration profile, setting the default region when prompted:
```bash
aws configure --profile ${PROFILE}
```

5. Set the default profile:
```bash
export AWS_DEFAULT_PROFILE=${PROFILE}
```

6. Create an S3 bucket to store your image in:
```bash
aws s3api create-bucket --acl private --bucket ${BUCKET} \
  --create-bucket-configuration LocationConstraint=${REGION} --region ${REGION} \
  --profile ${PROFILE}
```

7. Generate a hash for the image locally, to verify end-to-end integrity:
```bash
IMAGE_HASH=$(openssl dgst -md5 -binary ami-openbsd-amd64-68-YYMMDD.ova \
    | openssl enc -base64)
```

8. Upload your image to the new bucket:
```bash
aws s3api put-object --bucket ${BUCKET} --key ami-openbsd-amd64-68-YYMMDD.ova \
  --body ami-openbsd-amd64-68-YYMMDD.ova --profile ${PROFILE} --content-md5 ${IMAGE_HASH}
```
9. Create a role to allow the download and import of S3 images into EC2:
```bash
aws iam create-role --role-name vmimport \
  --assume-role-policy-document file://trust-policy.json \
  --profile ${PROFILE}
```

10. Edit the `role-policy.json` file adding your S3 bucket name, then attach the role policy to the trust policy created previously:
```bash
aws iam put-role-policy --role-name vmimport \
  --policy-name vmimport --policy-document file://role-policy.json
```

11. Edit the `containers.json` file, updating the `Description`, `S3Bucket` and `S3Key` as appropriate.  Now you can upload the image into EC2 from the S3 bucket:
```bash
aws ec2 import-image --description "Lappland OpenBSD amd64 68 YYYYMMDD" \
  --disk-container file://containers.json  \
  --region ${REGION}

aws ec2 import-snapshot --description "Lappland OpenBSD amd64 68 YYYYMMDD" \
--disk-container "file://containers.json"  \
--query "ImportTaskId" --region ${REGION}
```
Look out for `import-task-id` which will be output.  This is needed in the next step to get the SnapshotId.

12. Get the SnapshotId using the `import-task-id` output in the previous step:
```bash
aws --output json ec2 describe-import-snapshot-tasks  --region ${REGION} \
--import-task-ids import-snap-abcdef0123456789a
```

13. Get the ami using the SnapshotId output in the previous step:
```bash
aws ec2 register-image --name "openbsd-amd64-YYMMDD" --architecture x86_64 \
    --root-device-name /dev/sda1 --virtualization-type hvm \
    --description "Lappland OpenBSD amd64 68 YYYYMMDD" --block-device-mappings \
    DeviceName="/dev/sda1",Ebs={SnapshotId=snap-abcdef0123456789a} --region ${REGION}
```
