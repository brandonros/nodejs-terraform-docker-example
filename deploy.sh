#!/bin/sh
set -e
# build app
cd app && npm run docker:build && cd ..
# deploy infrastructure
terraform init
terraform plan -out plan
terraform apply plan
# cleanup
rm plan
