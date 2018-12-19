#!/bin/bash
# usage: ./publish-docker.sh master-123

set -e


VERSION=$1

NAME=spree
AWS_ACCOUNT_ID=229836376784

EB_BUCKET=elasticbeanstalk-us-east-1-$AWS_ACCOUNT_ID
ZIP=$VERSION.zip

aws configure set default.region us-east-1

# Authenticate against our Docker registry
eval $(aws ecr get-login --no-include-email)

# Build and push the image
docker build --build-arg CIRCLE_BUILD_NUM=$CIRCLE_BUILD_NUM --build-arg CIRCLE_BRANCH=$CIRCLE_BRANCH --build-arg CIRCLE_SHA1=$CIRCLE_SHA1 -t $NAME:$VERSION .
docker tag $NAME:$VERSION $AWS_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/$NAME:$VERSION
docker push $AWS_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/$NAME:$VERSION

# Replace the <AWS_ACCOUNT_ID> with the real ID
cp .circleci/Dockerrun.aws.json.tpl Dockerrun.aws.json
sed -i='' "s/<AWS_ACCOUNT_ID>/$AWS_ACCOUNT_ID/" Dockerrun.aws.json
# Replace the <NAME> with the real name
sed -i='' "s/<NAME>/$NAME/" Dockerrun.aws.json
# Replace the <TAG> with the real version number
sed -i='' "s/<TAG>/$VERSION/" Dockerrun.aws.json

# Zip up the Dockerrun file (feel free to zip up an .ebextensions directory with it)
zip -r $ZIP Dockerrun.aws.json .ebextensions

aws s3 cp $ZIP s3://$EB_BUCKET/$NAME/$ZIP

# Create a new application version with the zipped up Dockerrun file
aws elasticbeanstalk create-application-version --application-name "Spree" \
    --version-label $VERSION --source-bundle S3Bucket=$EB_BUCKET,S3Key=$NAME/$ZIP

