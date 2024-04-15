# aws-infrastructure

# master plan

1. manually create root aws account
	  - create a non-root user in the root account
	  - create access key & secret access key for non-root user
		  - allows deployment of resources to the root account
2. terraform project "aws-s3-statefiles"
	- goal: give statefiles a place to live
	- target account: variable
	- given an aws account,
		- create a S3 bucket
		- configure for no public access
		- turn on versioning
3. terraform project "aws-iam-ci" 
	- goal: allow deployment from GitHub Actions
	- target account: variable
	- given an account,
		- configure AWS IAM OIDC Provider to work with GitHub JWT generated during job runtime
4. terraform project "aws-org-manage"
	- goals: 
		- enable working with AWS Organizations
		- create & manage logical OUs
		- create & manage purposeful accounts
	- target account: root account
	- enable orgs
	- Create OUs
	- Manage OUs
	- Create accounts
	- Manage accounts
