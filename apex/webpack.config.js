"use strict";

const fs = require("fs");
let nodeModules = {};

fs.readdirSync(__dirname + "/node_modules")
.filter(dir => ".bin" !== dir)
.forEach(mod => nodeModules[mod] = `commonjs ${mod}`);

module.exports = {
  entry: "./index.js",
  target: "node",
  output: {
    path: "./lib",
    filename: "index.js",
    libraryTarget: "commonjs2"
  },
  module: {
    loaders: [
      {
        test: /\.js$/,
        loader: "babel",
        exclude: [/node_modules/]
      },
    ]
  },
  externals: nodeModules,
}
