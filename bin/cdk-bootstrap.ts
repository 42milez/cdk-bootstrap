#!/usr/bin/env node
import 'source-map-support/register';
import * as cdk from '@aws-cdk/core';
import { CdkBootstrapStack } from '../src/cdk-bootstrap-stack';
import { CdkBootstrapStack2 } from '../src/cdk-bootstrap-stack-2';

const env = process.env['STACK_ENV']
const app = new cdk.App();

new CdkBootstrapStack(app, `cdk-bootstrap-${env}`);
new CdkBootstrapStack2(app, `cdk-bootstrap-2-${env}`);
