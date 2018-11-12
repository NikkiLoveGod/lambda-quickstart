# Lambda init

Quickly create a local dev setup for Node lambda with package.json. 
Supports MFA requirement for AWS accounts.

## Setup

* Create aws lambda
* Clone this repo
* `cp .env.sample .env` and fill in your infos
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