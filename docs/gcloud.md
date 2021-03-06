# Google Cloud Platform Setup
- Follow the <a aria-label="See Google Cloud S D K installation instructions" href="https://cloud.google.com/sdk/docs/install" target="_blank" rel="nofollow noopener"><code>gcloud</code> installation instructions</a> for your platform.
- Log into your account with the <code>gcloud init</code> command.
- Define environment variables:
```bash
export PROJECT_NAME="lappland-santa"
export PROJECT_ID="lappland-santa-"`date +%F`
export BILLING_ID="<enter-your-billing-account-here>"
export CREDENTIALS="~/.config/gcloud/lappland-"`date +%F`.json
```
- Create a project and associate a billing account with it:
```bash
gcloud projects create ${PROJECT_ID} --name ${PROJECT_NAME} \
  --set-as-default
gcloud beta billing projects link ${PROJECT_ID} \
  --billing-account ${BILLING_ID}
```

- Create a service account with credentials (subsititute your-gcloud-account, typically the email of the account you use to administer gcloud):
```bash
gcloud iam service-accounts create lappland-santa --display-name "Lappland Santa"
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
  --member user:<your-gcloud-account> \
  --role roles/iam.serviceAccountAdmin
gcloud iam service-accounts keys create ${CREDENTIALS} \
  --iam-account lappland-santa@${PROJECT_ID}.iam.gserviceaccount.com
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
  --member serviceAccount:lappland-santa@${PROJECT_ID}.iam.gserviceaccount.com \
  --role roles/viewer
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
  --member serviceAccount:lappland-santa@${PROJECT_ID}.iam.gserviceaccount.com \
  --role roles/compute.admin
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
  --member serviceAccount:lappland-santa@${PROJECT_ID}.iam.gserviceaccount.com \
  --role roles/storage.admin
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
  --member serviceAccount:lappland-santa@{PROJECT_ID} iam.gserviceaccount.com \
  --role roles/iam.serviceAccountUser
```
**Attention**: take care of the credentials file, which contains the credentials to manage your Google Cloud account, including create and delete servers on this project.

- Enable the APIs:
```bash
gcloud services enable compute.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com
```

### Create a bucket for the image and upload it:
```bash
BUCKET="gs://<enter-a name-for-your-bucket>"
REGION="<your-region e.g. us-west1>"
gsutil mb -b on -l ${REGION} -p ${PROJECT_ID} ${BUCKET}
IMAGE_HASH=$(openssl dgst -md5 -binary openbsd-amd64-68-210101.tar.gz \
    | openssl enc -base64)
gsutil -h Content-MD5:${IMAGE_HASH} cp openbsd-amd64-68-210101.tar.gz \
    ${BUCKET}/openbsd-amd64-68-210101.tar.gz
```

If there was an error while uploading, get list of remote files (to check status) with:
```bash
gsutil ls ${BUCKET}
```
### Grant service account permission to pull image from the bucket:
```bash
gsutil iam ch serviceAccount:lappland-santa@${PROJECT_ID}.iam.gserviceaccount.com:objectViewer ${BUCKET}
```

Prove ownership of your domain before continuing.  You can do this by going to:

<a aria-label="Example link for proving domain ownership with Google" href="https://www.google.com/webmasters/verification/verification?domain=mail.example.com" rel="nofollow noopener noreferrer">https://www.google.com/webmasters/verification/verification?domain=mail.example.com</a>.

where mail.example.com is the domain you will use for your mail server.  This is needed in order to set the PTR record on the server.  To stay verified, do not remove the DNS record, even after verification succeeds.
