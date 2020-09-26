import { Construct } from '@aws-cdk/core';
import { Code, LayerVersion, Runtime } from '@aws-cdk/aws-lambda';

export function createLayers (scope: Construct, id: string, env: string): { [key: string]: LayerVersion } {
  return {
    baseLayer: new LayerVersion(scope, 'BaseLayer', {
      compatibleRuntimes: [
        Runtime.NODEJS_12_X
      ],
      code: Code.fromAsset(`layer.out/${env}/base1`),
      description: 'Base Layer 1',
      layerVersionName: `base-layer-1-${id}`
      // license: -
    })
  };
}
