# cdk-experiment
[![Build Status](https://travis-ci.org/42milez/cdk-experiment.svg?branch=master)](https://travis-ci.org/42milez/cdk-experiment)

cdk-experiment is an experimental project template based on AWS CDK. This project aims easy deployment of AWS resources that is generally used for web application.

## Features
- Multi CFn stack support
- Multi Lambda layer support
- Multi stage support (dev/stg/prod)
- etc.

## Requirements
- [Docker Compose](https://docs.docker.com/compose/install/)
- [aws-sam-cli](https://github.com/aws/aws-sam-cli)
- [jq](https://github.com/stedolan/jq)
- [yq](https://github.com/mikefarah/yq)

## Quick Start
⚠️ [Named profile](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html) is required when calling CFn's API. Named profile can be specified as `cli.profile` key in `cmd/config.yml`.

```
docker-compose build
docker-compose run --rm npm install
./cmd/code.sh build --env development
./cmd/cdk.sh bootstrap
./cmd/cdk.sh deploy --env development --stack 'service1,service2'
```

## Commands
- ⚠️ `--env` can be specified as `development`, `staging` or `production`.
- ⚠️ `development` is used as default when `--env` option is not specified.

#### Checking Code Style
```
./cmd/code.sh lint
```

#### Building the Project
```
./cmd/code.sh build
```

#### Deploying the CDK Toolkit Stack
```
./cmd/cdk.sh bootstrap
```

#### Deploying CFn Stacks
```
./cmd/cdk.sh deploy --env development --stack 'service1,service2'
```
###### Available Options:
- `--env`: Environment
- `--stack`: Stack Name (REQUIRED)

#### Listing CFn Stacks
```
./cmd/cdk.sh list --env development
```
###### Available Options:
- `--env`: Environment

#### Printing CFn Template
```
./cmd/cdk.sh synth --env development --stack 'service2'
```
###### Available Options:
- `--env`: Environment
- `--stack`: Stack Name (REQUIRED)

#### Destroying CFn Stacks
```
./cmd/cdk.sh destroy --env development --stack 'service1,service2'
```
###### Available Options:
- `--env`: Environment
- `--stack`: Stack Name (REQUIRED)

#### Invoking Lambda Function
```
./cmd/sam.sh --fid FUNCTION_IDENTIFIER --stack 'service2' --event 'empty.json'
```

Note: Function identifier is mentioned in [SAM CLI](https://docs.aws.amazon.com/cdk/latest/guide/sam.html).

###### Available Options:
- `--fid`: Function Identifier (REQUIRED)
- `--stack`: Stack Name (REQUIRED)
- `--event`: Event Data
