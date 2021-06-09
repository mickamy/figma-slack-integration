# figma-slack-integration

Post message to Slack channel when someone comments on a Figma file.
It uses figma webhook V2.
See docs for details.
https://www.figma.com/developers/api#webhooks_v2

## How to deploy

Assume you have installed ruby 2.7.0 or newer.

```
# Register your figma webhook
$ curl -X POST \
	-H 'X-FIGMA-TOKEN: <PERSONAL_ACCESS_TOKEN>' \
	-H "Content-Type: application/json" \
	'https://api.figma.com/v2/webhooks' \
	-d '{ \
		"event_type":"FILE_COMMENT", \
		"team_id":"<TEAM_ID>", \
		"endpoint":"<LAMBDA_ENDPOINT>", \
		passcode":"<PASSCODE>"
	}'

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
