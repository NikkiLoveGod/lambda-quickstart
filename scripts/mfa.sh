#!/bin/bash

# Parameter 1 is the name of the profile that is populated
# with keys and tokens.
KEY_PROFILE=${MFA_PROFILE:-$1}
IAM_USER_WITH_MFA=${AWS_PROFILE:-$2}
FORCE_RELOAD=${FORCE_RELOAD:-$3}

# The STS response contains an expiration date/ time.
# This is checked to only set the keys if they are expired.
EXPIRATION=$(aws configure get expiration --profile ${KEY_PROFILE})

RELOAD="true"
if [ -n "$EXPIRATION" ] && ! ${FORCE_RELOAD};
then
        # get current time and expiry time in seconds since 1-1-1970
        NOW=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

        # if tokens are set and have not expired yet
        if [[ "$EXPIRATION" > "$NOW" ]];
        then
                echo "Will not fetch new credentials. They expire at (UTC) $EXPIRATION"
                RELOAD="false"
        fi
fi

if [ "$RELOAD" = "true" ] || ${FORCE_RELOAD};
then
        echo "Need to fetch new STS credentials"
        MFA_SERIAL=$(aws configure get mfa_serial --profile ${IAM_USER_WITH_MFA})
        DURATION=$(aws configure get get_session_token_duration_seconds --profile ${IAM_USER_WITH_MFA})
        read -p "Token for MFA Device ($MFA_SERIAL): " TOKEN_CODE
        read -r AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN EXPIRATION < <(aws sts get-session-token \
                --profile ${IAM_USER_WITH_MFA} \
                --output text \
                --query 'Credentials.*' \
                --serial-number $MFA_SERIAL \
                --duration-seconds $DURATION \
                --token-code $TOKEN_CODE)

        aws configure set aws_secret_access_key "$AWS_SECRET_ACCESS_KEY" --profile "$KEY_PROFILE"
        aws configure set aws_session_token "$AWS_SESSION_TOKEN" --profile "$KEY_PROFILE"
        aws configure set aws_access_key_id "$AWS_ACCESS_KEY_ID" --profile "$KEY_PROFILE"
        aws configure set expiration "$EXPIRATION" --profile ${KEY_PROFILE}

        echo "Expiration: ${EXPIRATION}"
fi