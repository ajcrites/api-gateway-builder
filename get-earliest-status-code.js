#!/usr/bin/env node

let json = "";
process.stdin.resume();
process.stdin.on("data", chunk => json += chunk);
process.stdin.on("end", () => {
    const methodDetail = JSON.parse(json);
    console.log(
        Object.keys(methodDetail.methodResponses).reduce((lastCode, code) =>
            code < lastCode ? code : lastCode
        , 999)
    );
});
