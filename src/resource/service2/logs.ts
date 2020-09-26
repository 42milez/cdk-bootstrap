import { Construct } from '@aws-cdk/core';
import { Function } from '@aws-cdk/aws-lambda';
import { FilterPattern, LogGroup } from '@aws-cdk/aws-logs';
import { LambdaDestination } from '@aws-cdk/aws-logs-destinations';

import { getRetentionDays } from '../../../lib/cdk/logs_helper';

export function createLogs (scope: Construct, functions: {[key:string]: Function}) {
    return {
        helloCdkFunctionLogGroup: new LogGroup(scope, 'HelloCdkFunctionLogGroup', {
            logGroupName: '/aws/function/' + functions.hello.functionName,
            retention: getRetentionDays()
        })
    };
}
