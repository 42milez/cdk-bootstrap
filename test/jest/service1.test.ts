import { expect as expectCDK, matchTemplate, MatchStyle } from '@aws-cdk/assert';
import * as cdk from '@aws-cdk/core';
import * as CdkBootstrap from '../../src/stack/service1';

test('Empty Stack', () => {
  const app = new cdk.App();
  // WHEN
  const stack = new CdkBootstrap.Service1Stack(app, 'Service1Stack', 'development', 'cdk-bootstrap');
  // THEN
  expectCDK(stack).to(matchTemplate({
    Resources: {},
  }, MatchStyle.EXACT));
});
