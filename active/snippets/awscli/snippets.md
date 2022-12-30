active/kind-k8s/launch.sh# AWS CLI Snippets

## Query your ARN
```sh
PRINCIPAL_ARN=$(aws sts get-caller-identity --query Arn --output text)
```

## STS AssumeRole

```sh
$ aws sts assume-role --role-arn $ROLE_ARN \
     --role-session-name <ROLE_SESSION_NAME>
```
Produces output similar to the following:
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

You can extract the credential information using the following command line:
```sh
creds=$(aws --output text sts assume-role --role-arn <ROLE_ARN> \
  --role-session-name "<ROLE_SESSION_NAME>" | \
  | grep CREDENTIALS | cut -d " " -f2,4,5)
export AWS_ACCESS_KEY_ID=$(echo $creds | cut -d " " -f2)
export AWS_SECRET_ACCESS_KEY=$(echo $creds | cut -d " " -f4)
export AWS_SESSION_TOKEN=$(echo $creds | cut -d " " -f5)
```

## Change Account Password Policy
```sh
aws iam update-account-password-policy \
     --minimum-password-length 32 \
     --require-symbols \
     --require-numbers \
     --require-uppercase-characters \
     --require-lowercase-characters \
     --allow-users-to-change-password \
     --max-password-age 90 \
     --password-reuse-prevention true
```

## View Current Password Policy
```sh
aws iam get-account-password-policy
```

## Create an IAM Group
```sh
aws iam create-group --group-name <GROUP_NAME>
```

## Attach a polity to a Group
```sh
aws iam attach-group-policy --group-name <GROUP_NAME> \
     --policy-arn <POLICY_ARN>
```

## Create an IAM user
```sh
aws iam create-user --user-name <IAM_USER>
```
Produces output similar to the following:
```json
{
  "User": {
    "Path": "/",
    "UserName": "<IAM_USER>",
    "UserId": "HIDDEN_SECRET",
    "Arn": "<USER_ARN>",
    "CreateDate": "%Y-%m-%dT%H:%M:%S+%:::z"
  }
}
```

Where USER_ARN is formatted as follows: `arn:aws:iam::<ACCOUNT_ID>:user/<IAM_USER>`

## Generate a password that conforms to your policy
```sh
RANDOM_STRING=$(aws secretsmanager get-random-password \
--password-length 32 --require-each-included-type \
--output text \
--query RandomPassword)
```

## Associate a password with a user
```sh
aws iam create-login-profile --user-name <IAM_USER> \
     --password $RANDOM_STRING
```

## Add a user to a group
```sh
aws iam add-user-to-group --group-name <IAM_GROUP> \
     --user-name <IAM_USER>
```

### Create an IAM role from a JSON policy file
Create a file named assume-role-policy.json with the following contents:
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
```

Then run the following from the shell in the same directory:
```sh
aws iam create-role --assume-role-policy-document \
     file://assume-role-policy.json --role-name <IAM_ROLE_NAME>
```

Which should produce output similar to the following:
```json
{
  "Role": {
  "Path": "/",
  "RoleName": "<IAM_ROLE_NAME>",
  "RoleId": "<IAM_ROLE_ID>",
  "Arn": "<IAM_ROLE_ARN>",
  "CreateDate": "%Y-%m-%dT%H:%M:%S+%:::z",
  "AssumeRolePolicyDocument": {
    "Version": "2012-10-17",
    "Statement": [
    ...
```

## Associate a role with a policy
```sh
aws iam attach-role-policy --role-name <IAM_ROLE_NAME> \
     --policy-arn <IAM_POLICY_ARN>
```

## Use the IAM Policy Simulator to Simulate an Action Using A Specified Policy
```sh
aws iam simulate-principal-policy \
     --policy-source-arn <IAM_ROLE_ARN> \
     --action-names <ACTION>
```
`<ACTION>` example: ec2:CreateInternetGateway

Will produce output wimilar to the following:
```json
{
  "EvaluationResults": [
  {
    "EvalActionName": "<ACTION>",
    "EvalResourceName": "*",
    "EvalDecision": "implicitDeny",
    "MatchedStatements": [],
    "MissingContextValues": []
  }
  ]
}
```

## Create a Permission Boundary
Create a file named boundary-policy.json
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "CreateLogGroup",
      "Effect": "Allow",
      "Action": "logs:CreateLogGroup",
      "Resource": "arn:aws:logs:*:<AWS_ACCOUNT_ID>:*"
    },
    {
      "Sid": "CreateLogStreamandEvents",
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:<AWS_ACCOUNT_ID>:*"
    },
    {
      "Sid": "DynamoDBPermissions",
      "Effect": "Allow",
      "Action": [
        "dynamodb:PutItem",
        "dynamodb:UpdateItem",
        "dynamodb:DeleteItem"
      ],
      "Resource": "arn:aws:dynamodb:*:<AWS_ACCOUNT_ID>:table/AWSCookbook*"
    },
    {
      "Sid": "S3Permissions",
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Resource": "arn:aws:s3:::AWSCookbook*/*"
    }
  ]
}
```

Then create the permission boundary using the following shell command:
```sh
aws iam create-policy --policy-name <POLICY_NAME> \
     --policy-document file://boundary-policy.json
```

You should see output similar to the following:
```json
{
  "Policy": {
    "PolicyName": "<POLICY_NAME>",
    "PolicyId": "<POLICY_ID>",
    "Arn": "<POLICY_ARN>",
    "Path": "/",
    "DefaultVersionId": "v1",
    "AttachmentCount": 0,
    "PermissionsBoundaryUsageCount": 0,
    "IsAttachable": true,
    "CreateDate": "%Y-%m-%dT%H:%M:%S+%:::z",
    "UpdateDate": "%Y-%m-%dT%H:%M:%S+%:::z"
  }
}
```

## Connecting to EC2 instances when direct network access is unavailable

### Outline View
- Associate the AmazonSSMManagedInstanceCore policy with the instance
- Utilize the awscli running the `aws ssm start-session -target <INSTANCE_ID>` command.

You can create a role with the AmazonSSMManagedInstanceCore policy using the following awscli command:
```sh
aws iam attach-role-policy --role-name <SSM_MANAGED_INSTANCE_ROLE_NAME> \
     --policy-arn arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore
```

You can create an instance profile using thge following awscli command:
```sh
aws iam create-instance-profile \
     --instance-profile-name <INSTANCE_PROFILE_NAME>
```

Associate the role from above with the instance profile:
```sh
aws iam add-role-to-instance-profile \
     --role-name <SSM_MANAGED_INSTANCE_ROLE_NAME> \
     --instance-profile-name <INSTANCE_PROFILE_NAME>
```

Launch an instance using the new instance profile:
```sh
INSTANCE_ID=$(aws ec2 run-instances --image-id <AMI_ID> \
     --count 1 \
     --instance-type t3.nano \
     --iam-instance-profile Name=<INSTANCE_PROFILE_NAME> \
     --subnet-id $SUBNET_1 \
     --security-group-ids $INSTANCE_SG \
     --metadata-options \
HttpTokens=required,HttpPutResponseHopLimit=64,HttpEndpoint=enabled \
     --tag-specifications \
     'ResourceType=instance,Tags=[{Key=Name,Value=AWSCookbook106}]' \
     'ResourceType=volume,Tags=[{Key=Name,Value=AWSCookbook106}]' \
     --query Instances[0].InstanceId \
     --output text)
```

Note that `stty -echo` and `stty echo` will disable and enable SSM session logging respectively.

Note that SSM comminicates using TCP port 443. You may need to configure your VPC endpoints to ensure this is possible. When enabled, the SSM agent on your instance registers with the SSM service during boot. It does this using Amazon internal networks and so public-side facing security groups, etc need not be updated.

## How can one create a Key using KMS (Key Management Service)
```sh
KMS_KEY_ID=$(aws kms create-key --description "<NEW_KEY_NAME>" \
     --output text --query KeyMetadata.KeyId)
```

## How can you assign an alias to a key
```sh
aws kms create-alias --alias-name alias/<KEY_ALIAS_NAME> \
     --target-key-id <KMS_KEY_ID>
```

## How can one specify that a key rotate on a schedule

```sh
aws kms enable-key-rotation --key-id <KMS_KEY_ID>
```

## How can I specify the key to be used for EBS encryption
```sh
aws ec2 modify-ebs-default-kms-key-id \
     --kms-key-id alias/<KMS_KEY_ID or KEY_ALIAS_NAME>
```

##  How can I specify that EC2 encrypt EBS volumes by default?
```sh
aws ec2 enable-ebs-encryption-by-default
```

## How can I store a secret using the secrets manager
```sh
SECRET_ARN=$(aws secretsmanager \
     create-secret --name <[SECRET_PATH/]SECRET_NAME> \
     --description "SECRET_DESCRIPTION" \
     --secret-string "<SECRET_STRING>" \
     --output text \
     --query ARN)
```

## An example policy regarding secret manager actions:
create a file named secret-access-policy.json:
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "secretsmanager:GetResourcePolicy",
        "secretsmanager:GetSecretValue",
        "secretsmanager:DescribeSecret",
        "secretsmanager:ListSecretVersionIds"
      ],
      "Resource": [
        "SECRET_ARN"
      ]
    },
    {
      "Effect": "Allow",
      "Action": "secretsmanager:ListSecrets",
      "Resource": "*"
    }
  ]
}
```

and create a policy using the json file above:
```sh
aws iam create-policy --policy-name <POLICY_NAME> \
     --policy-document file://secret-access-policy.json
```

and grant an EC2 instance access to the secret:
```sh
aws iam attach-role-policy --policy-arn \
     arn:aws:iam::$AWS_ACCOUNT_ID:policy/<POLICY_NAME> \
     --role-name $ROLE_NAME
```

## How can I disable public access to an S3 bucket:
```sh
aws s3api put-public-access-block \
     --bucket <BUCKET_NAME> \
     --public-access-block-configuration \
"BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"
```

## How can one use the access analyzer to determine whether an S3 bucket is accessible to the public or not?

Create an analyzer:
```sh
ANALYZER_ARN=$(aws accessanalyzer create-analyzer \
     --analyzer-name <ANALYZER_NAME> \
     --type ACCOUNT \
     --output text --query arn)
```

Start a resource scan:
```sh
aws accessanalyzer start-resource-scan \
     --analyzer-arn $ANALYZER_ARN \
     --resource-arn <RESOURCE_ARN>
```

Obtain the current resource scan results (it may take some time, so re-qeury if necessary):
```sh
aws accessanalyzer get-analyzed-resource \
     --analyzer-arn $ANALYZER_ARN \
     --resource-arn <RESOURCE_ARN>
```

## Simple means of serving static web content from an s3 bucket

You can utilize a CloudFront instance along with an OAI(Origin Access Identity) to restrict access to the S3 bucket to that CloudFront instance.

Create the CloudFront OAI:
```sh
OAI=$(aws cloudfront create-cloud-front-origin-access-identity \
     --cloud-front-origin-access-identity-config \
     CallerReference="awscookbook",Comment="AWSCookbook OAI" \
     --query CloudFrontOriginAccessIdentity.Id --output text)
```

Create a file named distribution.json:
```json
{
    "Comment": "awscookbook template",
    "CacheBehaviors": {
        "Quantity": 0
    },
    "DefaultRootObject": "index.html",
    "Origins": {
        "Items": [
            {
                "S3OriginConfig": {
                    "OriginAccessIdentity": "origin-access-identity/cloudfront/CLOUDFRONT_OAI"
                },
                "Id": "S3-origin",
                "DomainName": "S3_BUCKET_NAME.s3.amazonaws.com"
            }
        ],
        "Quantity": 1
    },
    "PriceClass": "PriceClass_All",
    "Enabled": true,
    "DefaultCacheBehavior": {
        "TrustedSigners": {
            "Enabled": false,
            "Quantity": 0
        },
        "TargetOriginId": "S3-origin",
        "ViewerProtocolPolicy": "allow-all",
        "ForwardedValues": {
            "Headers": {
                "Quantity": 0
            },
            "Cookies": {
                "Forward": "none"
            },
            "QueryString": false
        },
        "SmoothStreaming": false,
        "AllowedMethods": {
            "Items": [
                "GET",
                "HEAD"
            ],
            "Quantity": 2
        },
        "MinTTL": 0
    },
    "CallerReference": "example",
    "ViewerCertificate": {
        "CloudFrontDefaultCertificate": true
    },
    "CustomErrorResponses": {
        "Quantity": 0
    },
    "Restrictions": {
        "GeoRestriction": {
            "RestrictionType": "none",
            "Quantity": 0
        }
    },
    "Aliases": {
        "Quantity": 0
    }
}
```

Create a CloudFront distribution in accordance to the distirbution.json specification:
```sh
DISTRIBUTION_ID=$(aws cloudfront create-distribution \
     --distribution-config file://distribution.json \
     --query Distribution.Id --output text)
```

It may take some time to create the distribution. The following command can be run, repeatedly to query the status of the distribution. The status will be 'Deployed' when it is done.
```sh
aws cloudfront get-distribution --id $DISTRIBUTION_ID \
    --output text --query Distribution.Status
```

Create a file named bucket-policy.json:
```json
{
  "Version": "2012-10-17",
  "Id": "PolicyForCloudFrontPrivateContent",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity CLOUDFRONT_OAI"
      },
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::S3_BUCKET_NAME/*"
    }
  ]
}
```

Apply the bucket-policy.json specification:
```sh
aws s3api put-bucket-policy --bucket <BUCKET_NAME> \
     --policy file://bucket-policy.json
```

Obtain the URL of the CloudFront distribution:
```sh
DOMAIN_NAME=$(aws cloudfront get-distribution --id $DISTRIBUTION_ID \
     --query Distribution.DomainName --output text)
```

Validate that it is serving content via web protocols:
```sh
curl $DOMAIN_NAME
```

## Create a VPC

Note that a VPC is a regional construct.
```sh
VPC_ID=$(aws ec2 create-vpc --cidr-block 10.10.0.0/16 \
    --tag-specifications
'ResourceType=vpc,Tags=[{Key=Name,Value=AWSCookbook201}]' \
    --output text --query Vpc.VpcId)
```


## Query or Describe an existing VPC

A VPC is a Regional construct in AWS. A Region is a geographical area, and Availability Zones are physical data centers that reside within a Region. For example, at the time of this writing there are three availability zones within the US-West region.

```sh
aws ec2 describe-vpcs --vpc-ids $VPC_ID
```

The above command will produce output similar to the following:

```json
{
  "Vpcs": [
  {
    "CidrBlock": "10.10.0.0/16",
    "DhcpOptionsId": "dopt-<<snip>>",
    "State": "available",
    "VpcId": "vpc-<<snip>>",
    "OwnerId": "111111111111",
    "InstanceTenancy": "default",
    "CidrBlockAssociationSet": [
      {
        "AssociationId": "vpc-cidr-assoc-<<snip>>",
        "CidrBlock": "10.10.0.0/16",
        "CidrBlockState": {
        "State": "associated"
        }
      }
    ],
    "IsDefault": false,
<<continued>>...
```

## Associate an additional CIDR block with an existing VPC

Note that per the VPC user guide, the initial quota of IPv4 CIDR blocks per VPC is 5. This can be raised to 50. The allowable number of IPv6 CIDR blocks per VPC is 1.

```sh
aws ec2 associate-vpc-cidr-block \
    --cidr-block 10.11.0.0/16 \
    --vpc-id $VPC_ID
```

## Create a routing table to support segmentation and redundancy

First, create a routing table:
```sh
ROUTE_TABLE_ID=$(aws ec2 create-route-table --vpc-id $VPC_ID \
    --tag-specifications \
'ResourceType=route-table,Tags=[{Key=Name,Value=AWSCookbook202}]' \
    --output text --query RouteTable.RouteTableId)
```

Now create two subnets, one in each of two availability zones within the region:
```sh
SUBNET_ID_1=$(aws ec2 create-subnet --vpc-id $VPC_ID \
    --cidr-block 10.10.0.0/24 --availability-zone ${AWS_REGION}a \
    --tag-specifications \
    'ResourceType=subnet,Tags=[{Key=Name,Value=AWSCookbook202a}]' \
    --output text --query Subnet.SubnetId)

SUBNET_ID_2=$(aws ec2 create-subnet --vpc-id $VPC_ID \
    --cidr-block 10.10.1.0/24 --availability-zone ${AWS_REGION}b \
    --tag-specifications \
    'ResourceType=subnet,Tags=[{Key=Name,Value=AWSCookbook202b}]' \
    --output text --query Subnet.SubnetId)
```

## Availability zone suffixes are randomized per account

If you would like to utilize AZs (availability zones) consistently across accounts, then use the following command to see the mapping for each:
```sh
aws ec2 describe-availability-zones --region $AWS_REGION
```

## Associate the routing table created with the two subnets

```sh
aws ec2 associate-route-table \
    --route-table-id $ROUTE_TABLE_ID --subnet-id $SUBNET_ID_1

aws ec2 associate-route-table \
    --route-table-id $ROUTE_TABLE_ID --subnet-id $SUBNET_ID_2
```

## Query the descripton of existing subnets

```sh
aws ec2 describe-subnets --subnet-ids $SUBNET_ID_1
aws ec2 describe-subnets --subnet-ids $SUBNET_ID_2
```

which for each subnet will create output similar to the following:

```json
{
  "Subnets": [
  {
    "AvailabilityZone": "us-east-1a",
    "AvailabilityZoneId": "use1-az6",
    "AvailableIpAddressCount": 251,
    "CidrBlock": "10.10.0.0/24",
    "DefaultForAz": false,
    "MapPublicIpOnLaunch": false,
    "MapCustomerOwnedIpOnLaunch": false,
    "State": "available",
    "SubnetId": "subnet-<<snip>>",
    "VpcId": "vpc-<<snip>>",
    "OwnerId": "111111111111",
    "AssignIpv6AddressOnCreation": false,
    "Ipv6CidrBlockAssociationSet": [],
<<continued>>...
```

## Query the description of a routing table

```sh
aws ec2 describe-route-tables --route-table-ids $ROUTE_TABLE_ID
```

which should generate output similar to the following:
```json
i{
  "RouteTables": [
  {
    "Associations": [
      {
        "Main": false,
        "RouteTableAssociationId": "rtbassoc-<<snip>>",
        "RouteTableId": "rtb-<<snip>>",
        "SubnetId": "subnet-<<snip>>",
        "AssociationState": {
        "State": "associated"
        }
      },
      {
        "Main": false,
        "RouteTableAssociationId": "rtbassoc-<<snip>>",
        "RouteTableId": "rtb-<<snip>>",
        "SubnetId": "subnet-<<snip>>",
        "AssociationState": {
        "State": "associated"
        }
      }
<<continued>>...
```

## Connecting Your VPC to the Internet Using an Internet Gateway

Here we assume you have an EC2 instance within at least one of the availability zones within the region that you have defined your VPC.

Furthermore you will use an internet gateway and an elastic IP address to allow access to that EC2 instance.

Let's create an internet gateway:
```sh
INET_GATEWAY_ID=$(aws ec2 create-internet-gateway \
    --tag-specifications \
'ResourceType=internet-gateway,Tags=[{Key=Name,Value=AWSCookbook202}]' \
    --output text --query InternetGateway.InternetGatewayId)
```

Attach the internet gateway to the existing VPC:
```sh
aws ec2 attach-internet-gateway \
    --internet-gateway-id $INET_GATEWAY_ID --vpc-id $VPC_ID
```

For each of two routing tables, create a route that sets the default routing destination to the newly created internet gateway
```sh
aws ec2 create-route --route-table-id $ROUTE_TABLE_ID_1 \
    --destination-cidr-block 0.0.0.0/0 --gateway-id $INET_GATEWAY_ID

aws ec2 create-route --route-table-id $ROUTE_TABLE_ID_2 \
    --destination-cidr-block 0.0.0.0/0 --gateway-id $INET_GATEWAY_ID
```

Create an EIP(Elastic IP):
```sh
ALLOCATION_ID=$(aws ec2 allocate-address --domain vpc \
    --output text --query AllocationId)
```

Now associate the EIP with an existing EC2 instance:
```sh
aws ec2 associate-address \
    --instance-id $INSTANCE_ID --allocation-id $ALLOCATION_ID
```

## Using a NAT Gateway for Outbound Internet Access from Private Subnets

Starting with a system with two availability zones. Within each you have one private, and one public subnet, and a routing table per subnet. Four subnets with routing tables in total across two AZs. You have one EC2 node in each private subnet, one per AZ.

Create an Elastic IP to be used with the NAT gateway
```sh
ALLOCATION_ID=$(aws ec2 allocate-address --domain vpc \
    --output text --query AllocationId)
```

Create a NAT gateway within the public subnet of the first AZ
  ```sh
  NAT_GATEWAY_ID=$(aws ec2 create-nat-gateway \
    --subnet-id $VPC_PUBLIC_SUBNET_1 \
    --allocation-id $ALLOCATION_ID \
    --output text --query NatGateway.NatGatewayId)
  ```

Check status until it comes up
```sh
aws ec2 describe-nat-gateways \
    --nat-gateway-ids $NAT_GATEWAY_ID \
    --output text --query NatGateways[0].State
```

Add a default route for 0.0.0.0/0 w/ dest. NAT gw to both private tier's route tables. This route will send all traffic not matching a more specific route to the dest. specified:
```sh
aws ec2 create-route --route-table-id $PRIVATE_RT_ID_1 \
    --destination-cidr-block 0.0.0.0/0 \
    --nat-gateway-id $NAT_GATEWAY_ID

aws ec2 create-route --route-table-id $PRIVATE_RT_ID_2 \
    --destination-cidr-block 0.0.0.0/0 \
    --nat-gateway-id $NAT_GATEWAY_ID
```

You can validate by connecting to both EC2 instances using SSM, and then trying to ping an outside host.

Note that in a production environment, you would likely want one NAT gateway per AZ.
