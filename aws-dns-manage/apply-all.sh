#!/usr/bin/env bash
set -e 

set_aws_account_number dns-manager

echo
echo "Creating DNS zones..."
echo

terraform -chdir=zones init "$(backend_config)"
terraform -chdir=zones apply --auto-approve

echo
echo "Use the nameservers output to update your domain registrar's nameservers."
echo "https://account.squarespace.com/domains"
echo

while true; do
    read -r -p "Have you updated the nameservers? Enter 'done' to continue or 'exit' to quit: " input
    if [[ "$input" == "done" ]]; then
        break # exit the loop
    elif [[ "$input" == "exit" ]]; then
        exit 1 # exit the script
    fi
done

echo
echo "Creating certificates for domains, validating DNS + certificates..."
echo

terraform -chdir=validation init "$(backend_config)"
terraform -chdir=validation apply --auto-approve

echo
echo "Creating permanent redirects..."
echo

terraform -chdir=redirects init "$(backend_config)"
terraform -chdir=redirects apply --auto-approve

echo "DNS configuration has completed."