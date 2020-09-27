#!/usr/bin/env node
import 'source-map-support/register';
import * as cdk from '@aws-cdk/core';
import { Service1Stack } from '../src/stack/service1';
import { Service2Stack } from '../src/stack/service2';

const APP_NAME = 'cdk-experiment';

const app = new cdk.App();
const env = app.node.tryGetContext('env');

new Service1Stack(app, `service1-${env}`, env, APP_NAME);
new Service2Stack(app, `service2-${env}`, env, APP_NAME);
