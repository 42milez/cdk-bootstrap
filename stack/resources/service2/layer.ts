import { Construct } from '@aws-cdk/core';
import { Code, LayerVersion, Runtime } from '@aws-cdk/aws-lambda';

export function createLayers (scope: Construct): {[key:string]: LayerVersion} {
    return {
        baseLayer: new LayerVersion(scope, 'BaseLayer', {
            compatibleRuntimes: [
                Runtime.NODEJS_12_X
            ],
            code: Code.fromAsset(`layer.out/${process.env.ENV}`),
            description: 'Base Layer',
            layerVersionName: `base-layer-${process.env.APP_NAME}-${process.env.ENV}`
            // license: -
        })
    };
}
