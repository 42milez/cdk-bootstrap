import { Construct } from '@aws-cdk/core';
import { Function } from '@aws-cdk/aws-lambda';
import { FilterPattern, LogGroup } from '@aws-cdk/aws-logs';
import { LambdaDestination } from '@aws-cdk/aws-logs-destinations';

import { getRetentionDays } from '../../../lib/cdk/logs_helper';

export function createLogs (scope: Construct, functions: {[key:string]: Function}) {
    return {
        helloWorldFunctionLogGroup: new LogGroup(scope, 'HelloWorldFunctionLogGroup', {
            logGroupName: '/aws/lambda/' + functions.helloWorld.functionName,
            retention: getRetentionDays()
        })
    };
}
