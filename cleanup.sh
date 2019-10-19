#!/bin/sh
set -e
# cleanup infrastructure
terraform destroy -auto-approve -var-file="variables.tfvars"
rm -rf volumes
# cleanup app
cd app && npm run docker:cleanup && cd ..
