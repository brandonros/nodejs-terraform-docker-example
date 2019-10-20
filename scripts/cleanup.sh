#!/bin/sh
set -e
# cleanup infrastructure
cd terraform
terraform destroy -auto-approve
cd ..
# cleanup volumes
rm -rf volumes
# cleanup app
cd app && npm run docker:cleanup && cd ..
