const handler = async function (event: any, context: any) {
  console.log(JSON.stringify(event));
  console.log(JSON.stringify(context));
};

export { handler };
