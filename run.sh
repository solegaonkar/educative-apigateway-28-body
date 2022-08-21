#!/bin/sh -v

# -----------------------------------------------------------------
# Configure the AWS CLI to let it communicate with your account
# -----------------------------------------------------------------
aws configure set aws_access_key_id $ACCESS_KEY_ID
aws configure set aws_secret_access_key $SECRET_ACCESS_KEY
aws configure set region us-east-1


# -----------------------------------------------------------------
# Open CloudFormation in the AWS Console 
# 1. Check for a Stack named EducativeCourseApiGateway
# 2. If there is such a stack, created in a previous lesson,
#    delete it by clicking on the Delete button
# 3. Wait for some time till it is deleted completely then press 
#    Enter to resume this script
# -----------------------------------------------------------------
read a

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
apiId=`aws cloudformation list-stack-resources --stack-name EducativeCourseApiGateway | jq -r ".StackResourceSummaries[0].PhysicalResourceId"`
echo "API ID: $apiId"

# -----------------------------------------------------------------
# This is the URL for the API we just created
# -----------------------------------------------------------------
url="https://${apiId}.execute-api.us-east-1.amazonaws.com/v1/whereami"
echo $url

# -----------------------------------------------------------------
# Invoke the URL to test the response
# -----------------------------------------------------------------
curl --location --request POST $url --header 'Content-Type: application/json' --data-raw '{  }' | jq 

