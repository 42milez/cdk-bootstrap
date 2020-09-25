import { SynthUtils } from '@aws-cdk/assert';
import { App } from '@aws-cdk/core';

import { Service2Stack } from '../../stack/service2';

test('Service2 Snapshot Test', () => {
    const app = new App();
    const stack = new Service2Stack(app, 'service2-development', 'development');
    expect(SynthUtils.toCloudFormation(stack)).toMatchSnapshot();
});
