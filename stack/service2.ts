import * as cdk from '@aws-cdk/core';

import { createFunctions } from './resources/service2/lambda';
import { createLayers } from './resources/service2/layer';
import { createLogs } from './resources/service2/logs';
import { createRoles } from './resources/service2/role';

export class Service2Stack extends cdk.Stack {
  constructor(scope: cdk.Construct, id: string, env: string, props?: cdk.StackProps) {
    super(scope, id, props);

    // IAM Roles
    const roles = createRoles(this, id);

    // Lambda Layers
    const layers = createLayers(this, id, env);

    // Lambda Functions
    const functions = createFunctions(this, id, roles, layers);

    // Log Groups
    createLogs(this, functions);
  }
}
