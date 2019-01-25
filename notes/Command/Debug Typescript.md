Debug ts in vscode, requires ts-node

launch.json

``` json
{
    "type": "node",
    "request": "launch",
    "name": "Current TS File",
    "args": ["${relativeFile}"],
    "runtimeArgs": ["--nolazy", "-r", "ts-node/register"],
    "sourceMaps": true,
    "cwd": "${workspaceRoot}",
    "protocol": "inspector"
}
```