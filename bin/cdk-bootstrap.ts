#!/usr/bin/env node
import 'source-map-support/register';
import * as cdk from '@aws-cdk/core';
import { Sample1Stack } from '../stack/sample1';
import { Sample2Stack } from '../stack/sample2';

const app = new cdk.App();
const env = app.node.tryGetContext('env')

new Sample1Stack(app, `sample1-${env}`);
new Sample2Stack(app, `sample2-${env}`);
