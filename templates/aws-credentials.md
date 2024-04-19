Dependencies:
- AWS account exists

Used by:
- awscli
- Terraform

https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html

The following profiles exist in `~/.aws/credentials` -

- `management-account`
    - this is a manually created user in the management/root account.

```ini
[management-account]
# your credentials go here
```