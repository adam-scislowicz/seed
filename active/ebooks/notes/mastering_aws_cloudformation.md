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

- **Optional values**
- **Multiline values**
- **Metadata section**
- **Parameters**


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
1. Properties
1. DependsOn
1. CreationPolicy
1. DeletionPolicy
1. UpdatePolicy
1. UpdateReplacePolicy

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

on page 61...
