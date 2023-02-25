# Notes


## Build up small set of trusted individuals

Work with them to outline potential projects.

Sketch out a bootstrapping plan, and use that to identify the skills necessary to bootstrap
said projects

map the individuals in my trust network to skills, availability, and interest.

Attempt to get consensus in order to engage in a project.


Focus the initial team on people who can participate in the exploratory phase. As outlined below:

Exploratory Phase

1. Marketing processes
  1. Product/service market fit / product/service definition
1. Digital media generation
  1. Produce & distribute media obtaining impression and engagement metrics during the iterative exploratory process
1. Due diligence processes
  1. Define problem (unmet need, spoken or unspoken)
  1. Investigate space of existing options and awareness/availability of them
  1. Define solution product and/or service. compare and contrast with existing options
  1. If compelling after speaking with the trust network, move on to scoping, finance, engineering, and business processes generally
1. Research processes
  1. In some scenarios due diligence may require studies to be performed. If existing studies cannot provide
     sufficient confidence, new studies may be warranted. Also, intermediate artifacts like meta-studies should
     be properly archived for later reference. This means due diligence work should also produce intermediate artifacts in order to optimize the entire process keeping in mind the future value of reusing such analysis.
     This goes back to the use of digital notebook archival that can be reused at a later date, this being more complete
    than the supplemental sections of papers that are so common today. Here instead I promote the use of a version
    control repository and a complete archive of dependencies.


## Practicals

1. Revenue generation to support me and my trust network. (bootstrapping a firm)

Some percentage of time must be spent bootstrapping projects which generate revenue for us so that we can continue to increase the amount of time we can spend under our own direction. The initial project vetting process intends to identify projects which can do that for us, and also for us to work together to define our small trust network. e.g. effectively partners in a firm.


## TODO

1. Continue Indigogo campaign. Need to start doing product placement / branding. Have a working prototype so you can list it as such on indigogo. Focus on this from the perspective of a marketing campaign.
1. Look into using a multi-stage build strategy in the combined dockerfile to reduce its size.
1. Build minimal Dockerfile's for use with kubernetes, these will obviously be very different than the aggregated seed Dockerfile which is as wide as possible to support discovery/exploration.
    - Build images for
        - caching 'proxy' for APT, PIP, NPM, etc. These will be used as the sources for container building.
1. Continue working on extropic.net/xnetworks-controld. This will drive aws iam, cloudformation, terraform, etc. Consider running it as a kubernetes service and having it get its configuration from etcd. It should be pretty easy to mate viper with etcd as an alternative to loading from a YAML file. E.g. initially loading a YAML file would push the configuration data to etcd. I can then look into using a distributed DB also within kubernetes along with a message system to implement xnetworks-controld as a distributed highly available system.
    - Get kubernetes up and add a DB and reliable message passing system and other support systems needed to support xnetworks-controld keeping its state in a reliable, distributed fashion.
    - Create a Cloudformation stack for kubernetes so that you can test it when cloud-hosted as well. e.g. Use ECS/EKS.
1. Look into rancher for kubernetes and similar
1. Setup PSQL (postgresql) as a HA (high-availability) service within your kubernetes stacks. See https://github.com/reactive-tech/kubegres, https://www.kubegres.io

## General Notes

- GEL: pulse alone
- XSL-08: continue, but increase dosage
    - Below if possible after MIA-602 suppresses GHRH:
        - JDJGYWSEMW restart, only while XSL-08 is effective
        - HFSH: restart, only use short acting and time with peak XSL-08
— new are below, important, sourcing please, these are probably somewhat hard to obtain in the proper dosages. —
    - GHRH Antagonist MIA-602 sub-q. Can reverse remodelling in some animals
    - trodusquemine (novel protein tyrosine phosphatase PTP-1B inhibitor)

If the new compounds cannot be sourced, see if a nearby clinic/hospital is willing to administer them. Also have the new compounds reviewed by an expert. Is it a reasonable experiment? There have been MI reverse-remodelling observations in animal models with MIA-602 with similar pre-conditions.

If the above fails, look into the following:

Intravascular lithotripsy, or I.V.L, less risk than rotational sanding devices for reducing arterial plaques. Not even sure if this is relavent.

## Extropic.net

### Marketing

Crowd Funding Sites

- Indigogo *this is often rated highly, maybe it has the most purchaser traffic in the segments I will be addressing?
- Crowd Supply *this looks good for tech focused products
- Kickstarter *still big

Facebook advertising. I should start experiments with this next month. Experiments can be run for a few hundred dollars at a time. This will be used to finish product placement and branding and to build an email list of likely purchasers. e.g. to prepare for a crowdfunding raise.

Iterate to build a Launch Email List
	Product Placement
	Branding

When the Launch Email List is big enough
	Start crowdfunding campaign

### xnetworks software

- xnetworks-controld protocol
    - daemon: xnetworks-controld: kubernetes hosted control daemon
    - cli app: xnetworks: cli to communicate with the control daemon

#### xnetworks-controld

Track state in etcd and a distributed transactional database.

## EKS Cluster Cloudformation Example

AWSTemplateFormatVersion: '2010-09-09'
Parameters:
  EKSIAMRoleName:
    Type: String
    Description: The name of the IAM role for the EKS service to assume.
  EKSClusterName:
    Type: String
    Description: The desired name of your AWS EKS Cluster.

  VpcBlock:
    Type: String
    Default: 192.168.0.0/16
    Description: The CIDR range for the VPC. This should be a valid private (RFC 1918) CIDR range.
  PublicSubnet01Block:
    Type: String
    Default: 192.168.0.0/18
    Description: CidrBlock for public subnet 01 within the VPC
  PublicSubnet02Block:
    Type: String
    Default: 192.168.64.0/18
    Description: CidrBlock for public subnet 02 within the VPC
  PrivateSubnet01Block:
    Type: String
    Default: 192.168.128.0/18
    Description: CidrBlock for private subnet 01 within the VPC
  PrivateSubnet02Block:
    Type: String
    Default: 192.168.192.0/18
    Description: CidrBlock for private subnet 02 within the VPC
Metadata:
  AWS::CloudFormation::Interface:
  ParameterGroups:
    -
      Label:
        default: "Worker Network Configuration"
      Parameters:
        - VpcBlock
        - PublicSubnet01Block
        - PublicSubnet02Block
        - PrivateSubnet01Block
        - PrivateSubnet02Block
Resources:
  EKSIAMRole:
    Type: 'AWS::IAM::Role'
    Properties:
      AssumeRolePolicyDocument:
        Version: 2012-10-17
        Statement:
          - Effect: Allow
          Principal:
            Service:
              - eks.amazonaws.com
          Action:
            - 'sts:AssumeRole'
      RoleName: !Ref EKSIAMRoleName
      ManagedPolicyArns:
        - arn:aws:iam::aws:policy/AmazonEKSClusterPolicy
        - arn:aws:iam::aws:policy/AmazonEKSServicePolicy
  VPC:
    Type: AWS::EC2::VPC
    Properties:
      CidrBlock:  !Ref VpcBlock
      EnableDnsSupport: true
      EnableDnsHostnames: true
    Tags:
    - Key: Name
      Value: !Sub '${AWS::StackName}-VPC'
  InternetGateway:
    Type: "AWS::EC2::InternetGateway"
    VPCGatewayAttachment:
    Type: "AWS::EC2::VPCGatewayAttachment"
    Properties:
      InternetGatewayId: !Ref InternetGateway
      VpcId: !Ref VPC
  PublicRouteTable:
    Type: AWS::EC2::RouteTable
    Properties:
      VpcId: !Ref VPC
    Tags:
    - Key: Name
      Value: Public Subnets
    - Key: Network
      Value: Public

  PrivateRouteTable01:
    Type: AWS::EC2::RouteTable
    Properties:
      VpcId: !Ref VPC
    Tags:
    - Key: Name
      Value: Private Subnet AZ1
    - Key: Network
      Value: Private01

  PrivateRouteTable02:
    Type: AWS::EC2::RouteTable
    Properties:
      VpcId: !Ref VPC
    Tags:
    - Key: Name
      Value: Private Subnet AZ2
    - Key: Network
      Value: Private02
  PublicRoute:
    DependsOn: VPCGatewayAttachment
    Type: AWS::EC2::Route
      Properties:
      RouteTableId: !Ref PublicRouteTable
      DestinationCidrBlock: 0.0.0.0/0
      GatewayId: !Ref InternetGateway
  PrivateRoute01:
    DependsOn:
    - VPCGatewayAttachment
    - NatGateway01
    Type: AWS::EC2::Route
    Properties:
      RouteTableId: !Ref PrivateRouteTable01
      DestinationCidrBlock: 0.0.0.0/0
      NatGatewayId: !Ref NatGateway01
  PrivateRoute02:
    DependsOn:
    - VPCGatewayAttachment
    - NatGateway02
    Type: AWS::EC2::Route
    Properties:
      RouteTableId: !Ref PrivateRouteTable02
      DestinationCidrBlock: 0.0.0.0/0
      NatGatewayId: !Ref NatGateway02
  NatGateway01:
    DependsOn:
    - NatGatewayEIP1
    - PublicSubnet01
    - VPCGatewayAttachment
    Type: AWS::EC2::NatGateway
    Properties:
      AllocationId: !GetAtt 'NatGatewayEIP1.AllocationId'
      SubnetId: !Ref PublicSubnet01
    Tags:
    - Key: Name
      Value: !Sub '${AWS::StackName}-NatGatewayAZ1'
  NatGateway02:
    DependsOn:
    - NatGatewayEIP2
    - PublicSubnet02
    - VPCGatewayAttachment
    Type: AWS::EC2::NatGateway
    Properties:
    AllocationId: !GetAtt 'NatGatewayEIP2.AllocationId'
    SubnetId: !Ref PublicSubnet02
    Tags:
    - Key: Name
      Value: !Sub '${AWS::StackName}-NatGatewayAZ2'
  NatGatewayEIP1:
    DependsOn:
    - VPCGatewayAttachment
    Type: 'AWS::EC2::EIP'
    Properties:
      Domain: vpc
  NatGatewayEIP2:
    DependsOn:
    - VPCGatewayAttachment
    Type: 'AWS::EC2::EIP'
    Properties:
      Domain: vpc
  PublicSubnet01:
    Type: AWS::EC2::Subnet
    Metadata:
      Comment: Subnet 01
    Properties:
      AvailabilityZone:
        Fn::Select:
        - '0'
        - Fn::GetAZs:
          Ref: AWS::Region
        CidrBlock:
          Ref: PublicSubnet01Block
        VpcId:
          Ref: VPC
    Tags:
    - Key: Name
      Value: !Sub "${AWS::StackName}-PublicSubnet01"
  PublicSubnet02:
    Type: AWS::EC2::Subnet
    Metadata:
      Comment: Subnet 02
    Properties:
      AvailabilityZone:
        Fn::Select:
        - '1'
        - Fn::GetAZs:
          Ref: AWS::Region
        CidrBlock:
          Ref: PublicSubnet02Block
        VpcId:
          Ref: VPC
    Tags:
    - Key: Name
      Value: !Sub "${AWS::StackName}-PublicSubnet02"
  PrivateSubnet01:
    Type: AWS::EC2::Subnet
    Metadata:
      Comment: Subnet 03
    Properties:
      AvailabilityZone:
        Fn::Select:
        - '0'
        - Fn::GetAZs:
          Ref: AWS::Region
        CidrBlock:
          Ref: PrivateSubnet01Block
        VpcId:
          Ref: VPC
    Tags:
    - Key: Name
      Value: !Sub "${AWS::StackName}-PrivateSubnet01"
    - Key: "kubernetes.io/role/internal-elb"
      Value: 1
  PrivateSubnet02:
    Type: AWS::EC2::Subnet
    Metadata:
      Comment: Private Subnet 02
    Properties:
      AvailabilityZone:
        Fn::Select:
        - '1'
        - Fn::GetAZs:
          Ref: AWS::Region
        CidrBlock:
          Ref: PrivateSubnet02Block
        VpcId:
          Ref: VPC
    Tags:
    - Key: Name
      Value: !Sub "${AWS::StackName}-PrivateSubnet02"
    - Key: "kubernetes.io/role/internal-elb"
      Value: 1
  PublicSubnet01RouteTableAssociation:
    Type: AWS::EC2::SubnetRouteTableAssociation
    Properties:
      SubnetId: !Ref PublicSubnet01
      RouteTableId: !Ref PublicRouteTable
  PublicSubnet02RouteTableAssociation:
    Type: AWS::EC2::SubnetRouteTableAssociation
    Properties:
      SubnetId: !Ref PublicSubnet02
      RouteTableId: !Ref PublicRouteTable
  PrivateSubnet01RouteTableAssociation:
    Type: AWS::EC2::SubnetRouteTableAssociation
    Properties:
      SubnetId: !Ref PrivateSubnet01
      RouteTableId: !Ref PrivateRouteTable01
  PrivateSubnet02RouteTableAssociation:
    Type: AWS::EC2::SubnetRouteTableAssociation
    Properties:
      SubnetId: !Ref PrivateSubnet02
      RouteTableId: !Ref PrivateRouteTable02
  ControlPlaneSecurityGroup:
    Type: AWS::EC2::SecurityGroup
    Properties:
      GroupDescription: Cluster communication with worker nodes
      VpcId: !Ref VPC
  EKSCluster:
    Type: AWS::EKS::Cluster
    Properties:
      Name: !Ref EKSClusterName
      RoleArn:
        "Fn::GetAtt": ["EKSIAMRole", "Arn"]
        ResourcesVpcConfig:
          SecurityGroupIds:
          - !Ref ControlPlaneSecurityGroup
          SubnetIds:
          - !Ref PublicSubnet01
          - !Ref PublicSubnet02
          - !Ref PrivateSubnet01
          - !Ref PrivateSubnet02
    DependsOn: [EKSIAMRole, PublicSubnet01, PublicSubnet02, PrivateSubnet01, PrivateSubnet02, ControlPlaneSecurityGroup]
Outputs:
  SubnetIds:
    Description: Subnets IDs in the VPC
    Value: !Join [ ",", [ !Ref PublicSubnet01, !Ref PublicSubnet02, !Ref PrivateSubnet01, !Ref PrivateSubnet02 ] ]
  SecurityGroups:
    Description: Security group for the cluster control plane communication with worker nodes
    Value: !Join [ ",", [ !Ref ControlPlaneSecurityGroup ] ]
  VpcId:
    Description: The VPC Id
    Value: !Ref VPC


### Semiconductor Ecosystem

https://www.piie.com/research/piie-charts/major-semiconductor-producing-countries-rely-each-other-different-types-chips

