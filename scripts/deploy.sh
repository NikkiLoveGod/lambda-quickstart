MFA=${MFA:-false}

# Quit on errors
set -e

# Get env variables
. .env

if $MFA; then
	./scripts/mfa.sh ${MFA_PROFILE} ${AWS_PROFILE} ${FORCE_RELOAD_MFA:-false}
	AWS_PROFILE=${MFA_PROFILE}
fi

zip -r lambda.zip .
AWS_PROFILE=${AWS_PROFILE} aws lambda update-function-code --function-name ${LAMBDA_NAME} --zip-file fileb://lambda.zip
rm -f lambda.zip