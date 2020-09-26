import { Construct, Stack } from '@aws-cdk/core';
import { Effect, PolicyDocument, PolicyStatement, Role, ServicePrincipal } from '@aws-cdk/aws-iam';

export function createRoles (scope: Construct, id: string): { [key: string]: Role } {
  return {
    lambdaRole: new Role(scope, 'LambdaRole', {
      assumedBy: new ServicePrincipal('function.amazonaws.com', {
        // conditions: -
        // region: -
      }),
      description: 'Hello CDK',
      inlinePolicies: {
        logs: new PolicyDocument({
          // assignSids: -
          statements: [
            new PolicyStatement({
              actions: [
                'logs:CreateLogGroup',
                'logs:CreateLogStream',
                'logs:PutLogEvents'
              ],
              effect: Effect.ALLOW,
              resources: [
                `arn:aws:logs:${Stack.of(scope).region}:${Stack.of(scope).account}:*`
              ]
              // conditions: -
              // notActions: -
              // notResources: -
              // notPrincipals: -
              // principals: -
              // sid: -
            })
          ]
        })
      },
      roleName: `lambda-${id}`
      // externalId: -
      // externalIds: -
      // managedPolicies: -
      // maxSessionDuration: -
      // path: -
      // permissionsBoundary: -
    })
  };
}
