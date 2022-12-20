# AWS CLI Snippets

## STS AssumeRole

```sh
$ aws sts assume-role --role-arn $ROLE_ARN \
     --role-session-name <ROLE_SESSION_NAME>
```
Prod
```json
{
  "Credentials": {
    "AccessKeyId": "<HIDDEN_SECRET>",
    "SecretAccessKey": "<HIDDEN_SECRET>",
    "SessionToken": "<HIDDEN_SECRET>",
    "Expiration": "%Y-%m-%dT%H:%M:%S+%:::z"
  },
  "AssumedRoleUser": {
    "AssumedRoleId": "<ROLE_SESSION_NAME>",
    "Arn": "<ROLE_ARN>"
  }
}
```