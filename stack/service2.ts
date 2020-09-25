import * as cdk from '@aws-cdk/core';

import { createFunctions } from './resources/lambda';
import { createLayers } from './resources/layer';
import { createLogs } from './resources/logs';
import { createRoles } from './resources/role';

export class Service2Stack extends cdk.Stack {
  constructor(scope: cdk.Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    // IAM Roles
    const roles = createRoles(this);

    // Lambda Layers
    const layers = createLayers(this);

    // Lambda Functions
    const functions = createFunctions(this, roles, layers);

    // Log Groups
    createLogs(this, functions);
  }
}
