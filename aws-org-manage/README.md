# aws-org-manage

# Creates and manages Organizational Units (OUs).

`main.tf`
- enable & manage AWS Organizations

`organizations.tf`
- create/manage OUs
- create/manage SCPs for OUs

# Creates and manages accounts

`accounts.tf` & `providers.tf`
- Create/manage accounts
    - accounts are assigned to OUs
    - accounts are given a role that allows management by the organzation
    - ${\color{orange}\text{try not to delete accounts. they don't immediately delete, they go into a suspended state for 90 days.}}$
- Add terraform statefile s3 bucket to account

# Creates and manages IAM-based access

`iam.tf` & `providers.tf`
- Create/manage users
- Create/manage org-managed IAM Roles