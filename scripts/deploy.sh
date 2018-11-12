LAMBDA_NAME=$1

zip -r lambda.zip .
aws lambda update-function-code --function-name $1 --zip-file fileb://lambda.zip
rm -f lambda.zip