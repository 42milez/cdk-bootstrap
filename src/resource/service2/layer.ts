import { Construct } from '@aws-cdk/core';
import { Code, LayerVersion, Runtime } from '@aws-cdk/aws-lambda';

export function createLayers (scope: Construct, id: string, env: string, appName: string): { [key: string]: LayerVersion } {
  return {
    baseLayer1: new LayerVersion(scope, 'BaseLayer1', {
      compatibleRuntimes: [
        Runtime.NODEJS_12_X,
      ],
      code: Code.fromAsset(`layer.out/${env}/base1`),
      description: 'Base Layer 1',
      layerVersionName: `base-layer-1-${appName}-${env}`,
      // license: -
    }),
    baseLayer2: new LayerVersion(scope, 'BaseLayer2', {
      compatibleRuntimes: [
        Runtime.NODEJS_12_X,
      ],
      code: Code.fromAsset(`layer.out/${env}/base2`),
      description: 'Base Layer 2',
      layerVersionName: `base-layer-2-${appName}-${env}`,
      // license: -
    }),
  };
}
