Discussion of deployed resources [here](https://chat.openai.com/share/4d60e1cb-a7d6-4485-a7ec-470b1d336285).

# Required Manual Steps
- Configure Route 53
    - `terraform apply`
    - A successful `apply` will output `nameservers` which are useful in a subsequent step.

- Log in to Squarespace:
    - Navigate to your account and select "Domains."
    - Choose the domain you want to manage.
- Navigate to DNS Settings:
    - Find the section for managing or configuring DNS and select the option to manage or change nameservers.
- Update Nameservers:
    - Replace the existing nameservers with the `nameservers` output provided by AWS Route 53 after you create the hosted zones.
    - Save the changes. Note that DNS changes can take some time to propagate, typically up to 48 hours.

- Verify Changes:
    - After updating the nameservers and allowing some time for propagation, use tools like nslookup or dig to ensure that your domains are resolving to the new AWS nameservers correctly.