#!/bin/sh -v

# -----------------------------------------------------------------
# Configure the AWS CLI to let it communicate with your account
# -----------------------------------------------------------------
aws configure set aws_access_key_id $ACCESS_KEY_ID
aws configure set aws_secret_access_key $SECRET_ACCESS_KEY
aws configure set region us-east-1

# -----------------------------------------------------------------
# With everything ready, we initiate the CloudFormation deployment.
# -----------------------------------------------------------------
aws cloudformation deploy \
    --template-file template.yml \
    --stack-name EducativeCourseApiGateway \
    --capabilities CAPABILITY_NAMED_IAM \
    --region us-east-1

# -----------------------------------------------------------------
# Get the API ID of the Rest API we just created.
# -----------------------------------------------------------------
apiId=`aws cloudformation list-stack-resources --stack-name EducativeCourseApiGateway | jq -r ".StackResourceSummaries[1].PhysicalResourceId"`
echo "API ID: $apiId"

# -----------------------------------------------------------------
# Deploy the API to a new Stage (We will discuss this in detail in a later chapter)
# -----------------------------------------------------------------
aws apigateway create-deployment --rest-api-id $apiId --stage-name v1 --description 'Deployed from CLI' 

# -----------------------------------------------------------------
# Give it some time to settle down
# -----------------------------------------------------------------
sleep 30

# -----------------------------------------------------------------
# This is the URL for the API we just created
# -----------------------------------------------------------------
url="https://${apiId}.execute-api.us-east-1.amazonaws.com/v1/whereami"
echo $url

# -----------------------------------------------------------------
# Invoke the URL to test the response
# -----------------------------------------------------------------
curl --location --request POST $url --header 'Content-Type: application/json' --data-raw '{  }' | jq 

