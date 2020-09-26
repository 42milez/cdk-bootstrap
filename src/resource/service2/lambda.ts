import { Construct, Duration } from '@aws-cdk/core';
import { Role } from '@aws-cdk/aws-iam';
import { AssetCode, Function, LayerVersion, Runtime, Tracing } from '@aws-cdk/aws-lambda';

export function createFunctions (scope: Construct, id: string, roles: { [key: string]: Role }, layers: { [key: string]: LayerVersion }): { [key: string]: Function } {
  return {
    hello: new Function(scope, 'HelloCdkFunction', {
      code: AssetCode.fromAsset('./src/function/hello'),
      description: 'Hello CDK',
      functionName: `hello-${id}`,
      handler: 'index.handler',
      memorySize: 128,
      role: roles.lambdaRole,
      runtime: Runtime.NODEJS_12_X,
      timeout: Duration.seconds(15),
      tracing: Tracing.ACTIVE
      // allowAllOutbound: -
      // deadLetterQueue: -
      // deadLetterQueueEnabled: -
      // environment: -
      // events: -
      // initialPolicy: -
      // logRetention: -
      // logRetentionRole: -
      // reservedConcurrentExecutions: -
      // securityGroup: -
      // securityGroups: -
      // vpc: -
      // vpcSubnets: -
    })
  };
}
