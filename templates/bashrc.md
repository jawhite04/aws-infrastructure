Dependencies:
- awscli
- [awscli configuration](./aws-config.md)

Used by:
- Terraform

These functions exist in `bash` sessions. I added them to a file `~/.bash_aws` and added `source ~/.bash_aws` to `~/.bashrc`.

```bash
statefile_bucket() {
  if [ -z "$AWS_ACCOUNT" ]; then
    echo "AWS_ACCOUNT is not set."
    exit 1
  else
    echo "terraform-statefiles-$AWS_ACCOUNT"
  fi
}

backend_config() {
        echo "--backend-config "bucket=$(statefile_bucket)""
}

set_aws_account_number() {
    # check that a profile name is provided
    if [ -z "$1" ]; then
        echo "Usage: set_aws_account_number <profile_name>"
        return 1
    fi

    local account_number=$(aws sts get-caller-identity --profile "$1" --output text --query 'Account')

    if [ $? -ne 0 ]; then
        echo "Failed to retrieve AWS account number for profile $1"
        return 1
    fi

    if [[ -n "$AWS_ACCOUNT" && "$account_number" != "$AWS_ACCOUNT" ]]; then
        echo
        echo -e "\e[31m-------------------------------------------------------------\e[0m"
        echo -e "\e[31m| AWS_ACCOUNT is changing from $AWS_ACCOUNT to $account_number |\e[0m"
        echo -e "\e[31m-------------------------------------------------------------\e[0m"
        echo
    fi

    export AWS_ACCOUNT=$account_number
    echo "AWS account number $AWS_ACCOUNT set for profile '$1'"
}

export -f set_aws_account_number
```
