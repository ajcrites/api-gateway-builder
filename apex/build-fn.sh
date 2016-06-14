#!/bin/bash -e

../../node_modules/.bin/webpack --config ../../webpack.config.js
cp ../../package.json package.json
npm install --production
rm package.json
