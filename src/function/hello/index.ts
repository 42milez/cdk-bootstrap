import * as fs from 'fs';

const handler = async function (event: any, context: any) {
  fs.readdir('/opt/nodejs', function (err: any, items: string[]) {
    if (err) {
      console.error(err);
    }
    for (let i = 0; i < items.length; i++) {
      console.log(items[i]);
    }
  });

  fs.readdir('/opt/nodejs/node_modules', function (err: any, items: string[]) {
    if (err) {
      console.error(err);
    }
    for (let i = 0; i < items.length; i++) {
      console.log(items[i]);
    }
  });

  const HELLO_1 = await import(`base-layer-1-cdk-experiment-${process.env.NODE_ENV}`);
  const HELLO_2 = await import(`base-layer-2-cdk-experiment-${process.env.NODE_ENV}`);

  console.log(JSON.stringify(event));
  console.log(JSON.stringify(context));
  console.log(HELLO_1.HELLO);
  console.log(HELLO_2.HELLO);
};

export { handler };
