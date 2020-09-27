import * as cdk from '@aws-cdk/core';

import { createFunctions } from '../resource/service2/lambda';
import { createLayers } from '../resource/service2/layer';
import { createLogs } from '../resource/service2/logs';
import { createRoles } from '../resource/service2/role';

export class Service2Stack extends cdk.Stack {
  constructor (scope: cdk.Construct, id: string, env: string, appName: string, props?: cdk.StackProps) {
    super(scope, id, props);

    // IAM Roles
    const roles = createRoles(this, id);

    // Lambda Layers
    const layers = createLayers(this, id, env, appName);

    // Lambda Functions
    const functions = createFunctions(this, id, env, roles, layers);

    // Log Groups
    createLogs(this, functions);
  }
}
