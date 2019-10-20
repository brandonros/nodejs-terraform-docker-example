# nodejs-terraform-docker-example
Example node.js app connected to Postgres + Redis with persistence + networking managed by Terraform

## Requirements

* Docker
* Terraform
* node.js + npm

## Deploy

`sh scripts/deploy.sh`

1. Builds + tags node.js app Docker image
1. Builds and applies Terraform plan


## Cleanup

`sh scripts/cleanup.sh`

1. Destroys Terraform deployment
1. Cleans up Docker volumes
1. Removes Docker image
