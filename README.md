# Lambda Quickstart

Quickly create a local dev setup for Node lambda with package.json. 
Supports MFA requirement for AWS accounts.

## Requirements

* AWS CLI (1.16.40 or so for MFA)

## Setup

* Create aws lambda
* Clone this repo
* `cp .env.sample .env` and fill in your infos

### For non-default profile and / or MFA

* Add your AWS and AWS MFA profile to your `~/.aws/credentials` and `~/.aws/config` files like so:
* Note: Mfa profile name doesnt matter, as long as its here and it matches the one on .env

```
# .aws/credentials
[<profile-name | mfa-account-profile-name>]
aws_access_key_id =
aws_secret_access_key =

# .aws/config
[profile <profile-name | mfa-account-profile-name>]
region = <region>
get_session_token_duration_seconds = <token-duration-for-mfa>

```

## Deployment

* Add your edits into index.js etc
* Run `npm run deploy`
* Go run your lambda


## TODO

* Automatically create lambda
* Run AWS lambda from cli
* Get lambda logs from cli
* Verify if this whole thing as any merit because of Serverless.com and AWS Cloud9 😛