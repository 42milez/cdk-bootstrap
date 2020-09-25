#!/usr/bin/env node
import 'source-map-support/register';
import * as cdk from '@aws-cdk/core';
import { Service1Stack } from '../stack/service1';
import { Service2Stack } from '../stack/service2';

const app = new cdk.App();
const env = app.node.tryGetContext('env')

new Service1Stack(app, `service1-${env}`);
new Service2Stack(app, `service2-${env}`);
