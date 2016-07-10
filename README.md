# API Gateway Build + Test Project
This is a project that was constructed to do the following:

* Provide one step to build a simple API Gateway + Lambda
 function + Database app
* Include the app router lambda code which is deployed with
 the rest of the build
* Include a node.js router that allows for local testing of
 the app router code so it can be done without deploying

This project exists as a discovery and teaching tool. It
was not built to serve the purpose of a particular project,
but individual projects can use this as a guide to serve
their own specific needs.

API Gateway Builder seeks to represent a project that is a
pure IaC solution with no manual / physical management of
architecture at all. Creation, maintenance, and destruction
of infrastructure can be maintained as code consistently
and each can be done with a minimal number of commands that
can naturally be integrated continuously.

This project also seeks to provide examples of how to build
infrastructure for development and avoiding some of the
pitfalls required with server(less) development to include
simulating infrastructure deployments locally.

## Installation Instructions
Install the following if you do not have them:

* [`terraform`](https://terraform.io)
* [`apex`](https://apex.run)
* [`aws` cli](http://docs.aws.amazon.com/cli/latest/userguide/installing.html)

## Deployment Instructions
An initial build is required to set up the infrastructure
for your personal development. Once you have set up the
infrastructure, you shouldn't need to do this again unless
you make modifications to the infrastructure itself.

Run `deploy.sh` to set up or modify the infrastructure.

Each time you make changes to the lambda functions, you can
run `provision/lambda.sh` to deploy the lamdba functions
only.

Running `node .` starts up the local express server for
testing purposes.

### Explanation of Deployment Steps
The deployment via `deploy.sh` will do each of the
following:

1. Convert `swagger.yaml` API definition to JSON. Currently
 the aws cli only supports swagger JSON importing, but
 yaml is easier for humans to deal with.
2. `terraform` deploys the infrastructure
 * Sets up roles
 * Creates API Gateway
 * Sets up DynamoDB
 * Deploys the app router lambda function
3. AWS CLI is used to import swagger definition into API
4. API Gateway is hooked up to app router lambda
