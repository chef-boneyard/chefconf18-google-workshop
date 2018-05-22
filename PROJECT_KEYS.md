# Generate Project Wide SSH Key

After installing GCloud SDK and creating an initial project, you can install an project-wide SSH that is used for all your instances.  Afterward, you can log into an instance with `ssh -i ~/.ssh/gce.key ubuntu@IP_ADDRESS`

```bash
export GCP_PROJECT=$(gcloud config list \
  --format 'value(core.project)'
)

# Local Key Path (default to use ~/.ssh)
[[ -d ${HOME}/.ssh ]] || mkdir ${HOME}/.ssh
KEY_PATH=${HOME}/.ssh
GCE_KEYS="${KEYPATH}/${GCP_PROJECT}.ssh-keys"

# Generate Your Key
ssh-keygen -t rsa -b 4096 -f "${KEYPATH}/gce.key" -C ubuntu -q -N ""
# Create Google Style ssh-key dsv (colon sep file)
printf '%s:%s\n' 'ubuntu' "$(cat ${KEYPATH}/gce.key.pub)" >> ${GCE_KEYS}

# Install Keys Into Project
gcloud compute project-info add-metadata \
  --metadata-from-file ssh-keys=${GCE_KEYS}
```
