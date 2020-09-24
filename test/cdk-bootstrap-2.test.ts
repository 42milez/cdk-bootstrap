import { expect as expectCDK, matchTemplate, MatchStyle } from '@aws-cdk/assert';
import * as cdk from '@aws-cdk/core';
import * as CdkBootstrap from '../src/cdk-bootstrap-stack-2';

test('Empty Stack', () => {
    const app = new cdk.App();
    // WHEN
    const stack = new CdkBootstrap.CdkBootstrapStack2(app, 'MyTestStack');
    // THEN
    expectCDK(stack).to(matchTemplate({
      "Resources": {}
    }, MatchStyle.EXACT))
});
