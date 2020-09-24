import { expect as expectCDK, matchTemplate, MatchStyle } from '@aws-cdk/assert';
import * as cdk from '@aws-cdk/core';
import * as CdkBootstrap from '../stack/sample2';

test('Empty Stack', () => {
    const app = new cdk.App();
    // WHEN
    const stack = new CdkBootstrap.Sample2Stack(app, 'MyTestStack');
    // THEN
    expectCDK(stack).to(matchTemplate({
      "Resources": {}
    }, MatchStyle.EXACT))
});
