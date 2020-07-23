# figma-slack-integration

Post message to Slack when someone comments on a Figma file

## How to deploy

Assume you have installed ruby 2.7.0 or newer.

```
$ bundle install --deployment

$ aws cloudformation package \
    --template-file template.yml \
    --output-template-file serverless-output.yml \
    --s3-bucket { BUCKET_NAME }

$ aws cloudformation deploy \
    --template-file serverless-output.yml \
    --stack-name FSIFunction \
    --capabilities CAPABILITY_IAM \
    --parameter-overrides SlackWebhookUrl={ SLACK_WEBHOOK_URL } Passcode={ PASSCODE }
```
