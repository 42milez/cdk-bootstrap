## cdk-bootstrap

[![Build Status](https://travis-ci.org/42milez/cdk-bootstrap.svg?branch=master)](https://travis-ci.org/42milez/cdk-bootstrap)

### Checking Code Style

```
./cmd/code.sh lint
```

### Building Sources

```
./cmd/code.sh build
```

### Deploying the CDK toolkit stack

```
./cmd/cdk.sh bootstrap
```

### Printing manifest

```
./cmd/cdk.sh list --env development
```

### Deploying the stacks

```
./cmd/cdk.sh deploy --env development --stack 'service1,service2'
```

### Printing the CloudFormation template

```
./cmd/cdk.sh deploy --env development --stack 'service1,service2'
```

### Destroying the stacks

```
./cmd/cdk.sh destroy --env development --stack 'service1,service2'
```
