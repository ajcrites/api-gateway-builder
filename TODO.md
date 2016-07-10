This is a high level TODO list of remaining features for
the initial release of API Gateway Builder.

These are mostly in order of priority and in many cases
dependency.

- [x] terraform modules example
- [x] apex example for lambda
- [x] integration of apex+terraform for deployment
- [x] API Gateway swagger deployment
- [ ] APIG deployment (integration request +
 responses automatically built from swagger)
- [ ] Complete `deploy` and `destroy` scripts
 (*NOTE:* current versions are shell using the AWS CLI,
 but I would prefer to write these as pure node + SDK)
- [ ] sample routes (for tagging images in DDB)
 - Only one or two sample routes is needed, but ultimately
  this can be a complete app
- [ ] lambda function that proxies to routes
- [ ] node app that sits on top of routes
 - similar to lambda, but simple for local debugging
- [ ] unit testing of routes / app
- [ ] `update` (IaC changes)
 - ideally implementing changes to swagger, but I'm open to
   any number of ideas
- [ ] Modularize API / swagger docs
- [ ] consolidate `deploy` + `update` for infrastructure
 maintenance as much as possible
- [ ] MetaDevOps (create IaC for CI for the project)
- [ ] Handle different integration point through swagger or
 other API document
 - API endpoint can be another lambda, S3, etc. We need to
  find a way to represent this in our canonical documents
- [ ] Configuration managemet (Chef?)
- [ ] Infrastructure testing (the dream)
