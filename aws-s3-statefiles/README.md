# Order of operations

## before starting,

ensure you are `source`d to the right aws account/credentials

## first, `./bootstrap.sh`

## then, `terraform apply`

1. `bootstrap.sh` (aws cli) creates the bucket
    - because the statefile has to go somewhere, and the bucket for the statefile doesn't exist yet
2. `bootstrap.sh` runs `terraform import` on the bucket
    - now the statefile has a place to live
3. `terraform apply` to manage the bucket