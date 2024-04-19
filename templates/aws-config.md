Dependencies:
- AWS account exists
- [`~/.aws/credentials`](./aws-credentials.md)

Used by:
- awscli
- Terraform

The following profiles exist in `~/.aws/config` -

Infrastructure
- `management-account`
    - The root user.
- `dns-manager`
    - The role created when the account was created by the organization.
- `route53-contributor`
    - A role which should be able to add and remove entries from Route 53 but denied everything else in that account.

Application
- `liine-take-home`
    - The role created when the account was created by the organization.
    - Intended for deploying 
- `aws-sandbox`
    - The role created when the account was created by the organization.
    - A generalized space to practice deployment, setup, management, teardown.

```ini
[profile management-account]
region = us-east-1
output = json

[profile liine-take-home]
role_arn = arn:aws:iam::<account number>:role/OrganizationAccountAccessRole
source_profile = management-account
region = us-east-1

[profile aws-sandbox]
role_arn = arn:aws:iam::<account number>:role/OrganizationAccountAccessRole
source_profile = management-account
region = us-east-1

[profile dns-manager]
role_arn = arn:aws:iam::<account number>:role/OrganizationAccountAccessRole
source_profile = management-account
region = us-east-1

[profile route53-contributor]
role_arn = arn:aws:iam::<account number>:role/route53-contributor
role_session_name = route53-contributor-session
source_profile = management-account
region = us-east-1
```
