#!/usr/bin/env node

let json = "";
process.stdin.resume();
process.stdin.on("data", chunk => json += chunk);
process.stdin.on("end", () => {
    const routes = JSON.parse(json);
    routes.items.filter(item => item.resourceMethods).map(item => {
        Object.keys(item.resourceMethods).map(method =>
            console.log(`--resource-id ${item.id} --http-method ${method} --integration-http-method ${method}`)
        );
    });
});
