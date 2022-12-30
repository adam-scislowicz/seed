# Mastering AWS CloudFormation

## Chapter 1: Refresher

Create a files names mybucket.yaml with the following contents:

```yaml
AWSTemplateFormatVersion: "2010-09-09"
Description: This is my first bucket
Resources:
    MyBucket:
        Type: AWS::S3::Bucket
```

```sh
aws cloudformation create-stack \ --stack-name mybucket\ --template-body file://mybucket.yaml
```

Update the mybucket.yaml file:

```yaml
AWSTemplateFormatVersion: "2010-09-09"
Description: This is my first bucket
Resources:
    MyBucket:
        Type: AWS::S3::Bucket
        Properties:
            AccessControl: PublicRead
```

```sh
aws cloudformation update-stack \ --stack-name mybucket\ --template-body file://mybucket.yaml
```

## Chapter 2: Advanced Template Development

CloudFormation template files are declarative rather than imperative. That is they define resources and their configuration parameters, rather than being imperative.

CloudFormation template high level structure:

- **AWSTemplateFormatVersion**
- **Description**
- **Metadata**
- **Parameters**
- **Mappings**
- **Conditions**
- **Transform**
- **Resources**
- **Outputs**

Other template field concepts:

- **Optional values**
- **Multiline values**

### Optional values

The **AWSTemplateFormatVersion** is currently optional as today there is only one valid value, being `"2010-09-09"`. It is recommended that it be present to avoid future ambiguity.

### Multiline values

The description field may be a single or multiline value.

### Metadata section

The metadata section allows for you to define your own associated metadata. An example from an existing application. Designer uses this to persist visual layout information.
Multiline values look as follows in the YAML file:

```yaml
Description: >
This is a multiline description
- With
- A
- Bullet List
```

### Parameters

This section allows for templates to be reusable.

Parameters example

```yaml
Parameters:
    InstanceType:
        Type: String
Resources:
    Ec2Instance:
        Type: AWS::EC2::Instance
        Properties:
            # …
            InstanceType: !Ref InstanceType
            # …
```

Parameters have the following properties:

- Default
- AllowedValues
- AllowedPattern

Example use of AllowedValues:

```yaml
Parameters:
    Environment:
        Type: String
        AllowedValues: [dev, test, prod]
```

Example use of AllowedPattern (uses Java regular expression syntax):

```yaml
Parameters:
    SubnetCidr:
        Type: String
        AllowedPattern: '((\d{1,3})\.){3}\d{1,3}/\d{1,2}'
```

There are many valid types besides String. Some examples include **AWS::EC2L:AvailabilityZone::Name**, **AWS::EC2::Image::Id**.

### Mappings

Mappings are similar to parameters but in a dictionary format.

```yaml
Mappings:
    RegionMap:
        us-east-1:
            HVM64: ami-0ff8a91507f77f867
            HVMG2: ami-0a584ac55a7631c0c
        us-west-1:
            HVM64: ami-0bdb828fd58c52235
            HVMG2: ami-066ee5fd4a9ef77f1
# ...
Resources:
    Ec2Instance:
        Type: "AWS::EC2::Instance"
        Properties:
            ImageId: !FindInMap [RegionMap, !Ref "AWS::Region", HVM64]
```

### Conditions

Conditions are similar to parameters, however the values of conditions can be only **true** or **false**.

```yaml
AWSTemplateFormatVersion: '2010-09-09'
Parameters:
    Env:
        Default: dev
        Description: Define the environment (dev, test or prod)
        Type: String
        AllowedValues: [dev, test, prod]
        Conditions:
            IsProd: !Equals [!Ref Env, 'prod']
        Resources:
            Bucket:
                Type: "AWS::S3::Bucket"
                Condition: IsProd
```

### Transform

The transform block will be covered later in the book.

### Resources

This is the primary, and only required section. It contains the resources that are to be provisioned.

Not all resource types are supported by CloudFormation. To see the current list please use the following reference. (ref: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-template-resource-type-ref.html)

Resources have the following attributes:

1. Type
2. Properties
3. DependsOn
4. CreationPolicy
5. DeletionPolicy
6. UpdatePolicy
7. UpdateReplacePolicy

### Outputs

Outputs are the values we export from the stack after its creation.

```yaml
Resources:
    Bob:
        Type: AWS::IAM::User
        Properties:
            UserName: Bob
    BobApiKey:
        Type: AWS::IAM::AccessKey
        Properties:
            UserName: !Ref Bob
Outputs:
    BobKey:
        Value: !Ref BobApiKey
    BobSecret:
        Value: !GetAttBobApiKey.SecretAccessKey
```

Outputs allow for what is called exports. These allow other templates to reference the exported values.

## Example multi-stack system

Example setup w/ a three-tier application, along with separate test and production networks.

Stacks:

- Network (VPC, Subnet, etc)
- IaC Security: IAM (roles and users)

The Network stack will contain the following elements

1. VPC
2. 3 public subnets
3. 3 WebTier subnets
4. 3 middleware subnets
5. 3 database subnets
6. 1 internet gateway
7. 1 NAT gateway
8. 1 public route table
9. 1 private route table
10. 2 IAM roles (for administrators and developers)

The above resources will have tags with as **Name**, and **Env**.

The network stack will have the following parameters:

1. VPC CIDR range
2. Public subnet 1 CIDR range
3. Public subnet 2 CIDR range
4. Public subnet 3 CIDR range
5. WebTier subnet 1 CIDR range
6. WebTier subnet 2 CIDR range
7. WebTier subnet 3 CIDR range
8. Middleware subnet 1 CIDR range
9. Middleware subnet 2 CIDR range
10. Middleware subnet 3 CIDR range
11. Database subnet 1 CIDR range
12. Database subnet 2 CIDR range
13. Database subnet 3 CIDR range
14. Environment

All of the above paraeters will be of type **String**.

example:

```yaml
# ...
Parameters:
    VpcCidr:
        Type: String
        AllowedPattern: '((\d{1,3})\.){3}\d{1,3}/\d{1,2}'
# ...
    Environment:
        Type: String
        AllowedValues: ['prod', 'test']
# ...
```

An exampole from the **Resource** section:

```yaml
# core.yaml
# ...
Resources:
    Vpc:
        Type: "AWS::EC2::VPC"
        Properties:
            CidrBlock: !Ref 'VpcCidr'
            EnableDnsHostnames: True
            EnableDnsSupport: True
            InstanceTenancy:
            Default Tags:
                - Key: 'Name'
                Value: !Join ['-', [ !Ref 'Environment', 'vpc' ]]
                - Key: 'Env'
                Value: !Ref 'Environment'
# ...
    PublicSubnet1:
        Type: "AWS::EC2::Subnet"
        Properties:
            CidrBlock: !Ref 'PublicSubnetCidr1'
            VpcId: !Ref Vpc
# ...
```

Paramerters can be specified on the command line or passed using a parameter file. The parameter file is JSON formatted.

Here is an example parameter file in JSON format:

```json
// testing.json
[
    {
        "ParameterKey": "Environment",
        "ParameterValue": "Testing"
    },
    {
        "ParameterKey": "VpcCidr",
        "ParameterValue": "10.0.0.0/16"
    },
// ...
]
```

Then following shell command used to specify the stack be created utilizing the parameters as specified in a parameter file.

```sh
$ aws cloudformaiton create-stack \
    --stack-name core \
    --template-body file://core.yaml \
    --parameters file://testing.json
```

Parsmeters can also be overridden on the command line as follows:

```sh
$ aws cloudformation create-stack \
    --stack-name core \
    --template-body file://core.yaml \
    --parameters \
    ParameterKey="Environment",ParameterValue="Testing" \
    ParameterKey="VpcCid",ParameterValue="10.0.0.0/16"
```

List type paramerters values specified on the command line are to be delimited as follows:

```
ParameterKey=List,ParameterValue=Element1\\,Element2
```

Furthermore if PublicSubnetCids is passed as a list, the **Fn::Select** function can be used to address the individual elements, as in the following example.

```yaml
# ...
    PublicSubnet1:
        Type: "AWS::EC2::Subnet"
        Properties:
            CidrBlock: !Select [0, 'PublicSubnetCidrs']
            VpcId: !Ref Vpc
# ...
```

Furthermore we can use the **Fn::Cidr** to generate the CIDR list, and thrn select from it. Here is an example:

```yaml
# ...
    PublicSubnet1:
        Type: "AWS::EC2::Subnet"
        Properties:
            CidrBlock: !Select [0, !Cidr [ !GetAttVpcCidr, 9, 8 ]]
            VpcId: !Ref Vpc
    PublicSubnet2:
        Type: "AWS::EC2::Subnet"
        Properties:
            CidrBlock: !Select [1, !Cidr [ !GetAttVpcCidr, 9, 8 ]]
            VpcId: !Ref Vpc
# ...
```

An example of a Conditional

```yaml
Parameters:
    Env: 
        Type: String
        Default: test
        AllowedValues: [ "test", "prod" ]
    ImageId:
        Type: AWS::SSM::Parameter::Value<AWS::EC2::Image::Id>
        Default: '/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2'
Conditions:
    IsProd: !Equals [ !Ref Env, "prod" ]
Resources:
    WebLt:
        Type: AWS::EC2::LaunchTemplate
        Properties:
            LaunchTemplateName: web
            LaunchTemplateData:
            ImageId: !Ref ImageId
            InstanceType: !If [ IsProd, m5.large, t3.micro ]
# ...
```

alternatively **InstanceType** could be specifed as follows:

```yaml
# ...
            InstanceType:
                Fn::If: 
                    - IsProd
                    - m5.large
                    - t3.micro
#...
```

furthermore you can nest conditional expressions. Here is an example:

```yaml
# ...
            InstanceType: !If [ IsProd, m5.large, !If [ IsStaging, t3.large, t3.micro ] ]
# ...
```

## DeletionPolicy

Deletion policies can be used to trigger specific actions upon the deletion of, or prevent the deletion of specific resources.

The following example will force a snapshot to be taken just before deleting a resource that is an instance of an RDS.

```yaml
# ...
Resources: 
    VeryImportantDb:
        Type: AWS::RDS::Instance
        DeletionPolicy: Snapshot
        Properties: # Here you set properties for your RDS instance.
# ...
```

Other resources which support the Snapshot type deletion policy, at least at the time the list was made are: AWS::EC2::Volume, AWS::ElastiCache::CacheCluster, AWS::ElastiCache::ReplicationGroup, AWS::Neptune::DBCluster, AWS::RDS::DBCluster, and AWS::RDS::DBInstance, AWS::Redshift::Cluster.

There is another deletion policy called Retain. In this case the CloudFormation state will clear the resource, howeer the resource will not actually be deleted cloud-side.

Here is an example use of the Retain deletion policy:

```yaml
# ...
Resources:
    EvenMoreImportantDb:
        Type: AWS::RDS::Instance
        DeletionPolicy: Retain
        Properties: # Here you set properties for your RDS instance.
# ...
```

The default policy is Delete, which as you might expect deletes the resource.

Note that deletion policies cannot be combined with Conditions. For that reason you may need to duplicate resource definitions. See the following example:

```yaml
# ...
Parameters:
    Environment:
        Type: String AllowedValued: [ "dev", "test", "prod" ]
        Default: "dev"
# ...
Conditions:
    ProdEnv: !Equals [ !Ref Environment, "prod" ]
    TestEnv: !Equals [ !Ref Environment, "test" ]
    DevEnv: !Equals [ !Ref Environment, "dev" ]
# ...
Resources:
    ProdDatabase:
        Condition: ProdEnv
        Type: AWS::RDS::DBInstance
        DeletionPolicy: Retain
        Properties: # Properties for production database
    TestDatabase:
        Condition: TestEnv
        Type: AWS::RDS::DBInstance
        DeletionPolicy: Snapshot
        Properties: # Properties for test database
    DevDatabase:
        Condition: DevEnv
        Type: AWS::RDS::DBInstance
        DeletionPolicy: Delete
        Properties: # Properties for dev database
# ...
```

## Importing and Exporting Values

The networking stack with exports.

```yaml
# core.yaml
# ...
Parameters:
# ...
Resources:
    Vpc:
        Type: AWS::EC2::VPC
        Properties:
# ...
    PublicSubnet1:
        Type: AWS::EC2::Subnet
        Properties:
# ...
Outputs:
    VpcId:
        Value: !Ref Vpc
        Export:
            Name: Vpc
    PublicSubnet1Id:
        Value: !Ref PublicSubnet1
        Export:
            Name: PublicSubnet1Id
# ...
```

The webteir stack importing aka refencing the core stack exported values.

```yaml
# webtier.yaml
Resources:
    WebTierAsg:
        Type: AWS::AutoScaling::AutoScalingGroup
        Properties:
# ...
    VpcZoneIdentifier:
        - !ImportValue PublicSubnet1Id
        - !ImportValue PublicSubnet2Id
        - !ImportValue PublicSubnet3Id
# ...
```

When the above three imports are specified as they are above in the VpcZoneIdentifier resource section, it produces a list of the three values.

Furthermore the above could be refactored as follows:

```yaml
# core.yaml
# ...
Outputs:
    PublicSubnetIds:
        Value: !Split [",", !Join [",", [!Ref PublicSubnet1, !Ref PublicSubnet2, !Ref PublicSubnet3]  ]  ]
        Export:
            Name: PublicSubnetIds
# ...
```

```yaml
# webtier.yaml
# ...
Resoures:
    WebTierAsg:
        Type: AWS::AutoScaling::AutoScalingGroup
        Properties:
# ...
            VpcZoneIdentifier: !ImportValuePublicSubnetIds
# ...
```

The Outputs section also support conditions but it does not have a condition attribute and you will have to use conditional functions:

```yaml
Outputs:
    DbEndpoint:
        Value: !If [ ProdEnv, !GetAttProdDatabase.Endpoint.Address, !If [ TestEnv, !GetAttTestDatabase.Endpoint.Address,!GetAtt.DevDatabase.Endpoint.Address ]]
        Export:
            Name: DbEndpoint
```

In this case the nested conditionals are difficult to read and the long-form syntax may be more readable as below:

```yaml
Outputs:
    DbEndpoint:
        Value:
            Fn::If:
                - ProdEnv
                - !GetAttProdDatabase.Endpoint.Address
                - Fn::If:
                    - TestEnv
                    - !GetAttTestDatabase.Endpoint.Address
                    - !GetAttDevDatabase.Endpoint.Address
        Export:
            Name: DbEndpoint
```

### AWS pseudo parameters:

- AWS:AccountId
- AWS::NotificationARNs
- AWS::NoValue
- AWS::Region
- AWS::StackId
- AWS::StackName
- AWS::URLSuffix
- AWS:Partition

Example use of pseudo parameters:

```yaml
Resources:
    MyIamRole:
        Type: AWS::IAM::Role
        Properties:
            AssumeRolePolicyDocument:
                Version: 2012-10-17
                Statement:
                    - Effect: Allow
                    Action:
                        - sts:AssumeRole
                    Principal:
                        AWS: !Ref "AWS::AccountId"
                    Sid: "AllowRoleAssume"
                    # The rest of the IAM role properties...
```

started at 11:26

Example combining pseudo parameters with an intrinsic function:

Note that the double dash '- -' syntax within the YAML example below denotes the creation of a list as follows:
`[ "arn:aws:iam::", <AWS::AccountId>, ":user/${aws.username}" ]`.

```yaml
MyIamRole:
    Type: AWS::IAM::Role
    Properties:
        AssumeRolePolicyDocument:
            Version: 2012-10-17
            Statement:
                - Sid: AllowAssumeRole
                Effect: Allow
                Principal:
                    AWS:
                        - !Join
                            - ""
                            - - "arn:aws:iam::"
                                - !Ref "AWS::AccountId"
                                - ":user/${aws.username}"
                Action: "sts:AssumeRole"
```

AWS::NoValue is similar to null. Its assignment to a field is treated as if that field has not been assigned at all.
The example below will restore from a snapshot if UseBSSnapshot is true.

```yaml
Resources:
    MyDB:
        Type: AWS::RDS::DBInstance
        Properties:
            AllocatedStorage: "5"
            DBInstanceClass: db.t3.micro
            Engine: MySQL
            EngineVersion: "5.7"
            DBSnapshotIdentifier:
                Fn::If:
                    - UseDBSnapshot
                    - Ref: DBSnapshotName
                    - Ref: AWS::NoValue
# ...
```

Using the AWS::Region pseudo-parameter

```yaml
Resources:
    EcsTaskDefinition:
        Type: AWS::ECS::TaskDefinition
            Properties:
            # Some properties... 
            ContainerDefinition:
                - Name: mycontainer
                # Some container properties...
                LogConfiguration:
                LogDriver: awslogs
                Options:
                    awslogs-group: myloggroup
                    awslogs-region: !Ref "AWS::Region"
                    awslogs-stream-prefix: ""
# ...
```

The AWS::StackName pseudo-parameter will refer to the CloudFormation stack that the resource belongs to.

```yaml
Resources:
    SomeResource:
        Type: # any, that supports tags
# ...
        Properties:
# Some properties ...
            Tags:
                - Key: Application
                Value: !Ref "AWS::StackName"
# ...
```

Note that in addition to the AWS::StackName pseudo-parameter, there is also an AWS::StackId pseudo-parameter.

The AWS::URLSuffix can be used to construct AWS URLs. This is most often amazonaws.com, however if you are utilizing the China cloud, or the AWS GovCloud then it will be different.

See the following example:

```yaml
Resources:
# ...
    EcsTaskExecutionRole:
        Type: AWS::IAM::Role
        Properties:
# ...
            AssumeRolePolicyDocument:
                Version: 2012-10-17
                Statement:
                    - Sid: AllowAssumeRole
                        Effect: Allow
                        Principal:
                            Service: !Join ["." [ "ecs-tasks",!Ref "AWS::URLSuffix" ] ]
                        Action: "sts:AssumeRole"
# ...
```

AWS::Partition will return the name of the partition being used. That standard partition is 'aws', and the China partition is 'aws-cn', while the US government cloud is 'aws-us-gov'.

### Dynamic Parameters

While static parameters can be passed using a static file in JSON format, ot via the command line. Dynamic parameters can be stored and referenced by using the SSM Parameter Store, and/or the Secrets Manager.

Both the parameter store and secrets manager support versioning. 

Here is an example of utilizing the SSM parameter store:

```yaml
Resources:
# ...
    WebAsgMinSize:
        Type: AWS::SSM::Parameter
        Properties:
            Type: String
            Value: "1"
    WebAsgMaxSize:
        Type: AWS::SSM::Parameter
        Properties:
            Type: String
            Value: "1"
    WebAsgDesiredSize:
        Type: AWS::SSM::Parameter
        Properties:
            Type: String
            Value: "1"
# ...
```

You can then add these parameters to the outputs so that you can obtain their current value:

```yaml
Outputs:
# ...
    WebAsgMinSize:
        Value: !Ref WebAsgMinSize
        Export:
            Name: WebAsgMinSize
    WebAsgMaxSize:
        Value: !Ref WebAsgMaxSize
        Export:
            Name: WebAsgMaxSize
    WebAsgDesiredSize:
        Value: !Ref WebAsgDesiredSize
        Export:
            Name: WebAsgDesiredSize
# ...
```

Parameters can also be referenced directly from the Resources section utilizing Jinja formatting. See the following exmaple:

```yaml
Resources:
# ...
    WebTierAsg:
        Type: AWS::AutoScaling::AutoScalingGroup
        Properties:
# ...
            DesiredCapacity:
                Fn::Join:
                    - ":"
                    - - "{{resolve:ssm"
                        - !ImportValueWebAsgDesiredSize
                        -"1}}"
            MaxSize:
                Fn::Join:
                    - ":"
                    - - "{{resolve:ssm"
                        - !ImportValueWebAsgMaxSize
                        - "1}}"
            MinSize:
                Fn::Join:
                    - ":
                    - - "{{resolve:ssm"
                        - !ImportValueWebAsgMinSize
                        - "1}}"
# ...
```
A similar method can be used to generate a DB password, so that it need not be hard-coded. Here is an example:

```yaml
Resources:
    DbPwSecret:
        Type: AWS::SecretsManager::Secret
        Properties:
            GenerateSecretString:
            GenerateStringKey: "DbPassword"
    RdsInstance:
        Type: AWS::RDS::DBInstance
        Properties:
# ...
            MasterUserPassword:
                Fn::Join:
                    - ":"
                    - - "{resolve:secretsmanager"
                        - !RefDbPwSecret
                        - "SecretString:DbPassword}}"
# ...
```
### References

1. [Template Anatomy](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/template-anatomy.html)