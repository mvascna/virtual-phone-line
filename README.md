# virtual-phone-line
1. Create a `mvana` aws credentials profile with `aws configure --profile=mvana`.
2. Create a `variable.tfvars`, and set `twilio_account_sid`, `twilio_auth_token`, and `google_maps_api_key`.
3. `terraform apply -var-file variable.tfvars`
4. Build the docker image in `docker/`, and push the image to the ECR repo.
