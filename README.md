# figma-slack-integration

Post message to Slack when someone comments on a Figma file

## How to deploy

Before deploying, check if you replaced environment variables in `template.yml`.
Following environment variables should to be updated.

- SLACK_WEBHOOK_URL
- PASSCODE

Then just hit command...

```
$ aws cloudformation package \
    --template-file template.yml \
    --output-template-file serverless-output.yml \
    --s3-bucket { BUCKET_NAME }

$ aws cloudformation deploy \
    --template-file serverless-output.yml \
    --stack-name FSIFunction \
    --capabilities CAPABILITY_IAM
```
