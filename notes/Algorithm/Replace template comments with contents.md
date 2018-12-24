``` javascript
const fs = require("fs");
const assert = require("assert");
const path = require("path");
const readline = require("readline");

function replaceTemplate(fp, temp, lines, indent = 2) {
  const tempHeader = 1;
  const tempBody = 2;
  const tempOutside = 3;
  const stateStack = [];
  let indentSpaces = "";
  for (let i = 0; i < indent; i++) {
    indentSpaces += " ";
  }
  let indentToUse = "";
  let outBuffer = "";
  let tempId = "";
  const lr = readline.createInterface({
    input: fs.createReadStream(fp)
  });
  stateStack.push(tempOutside);
  lr.on("line", (line) => {
    const regex = /(\s*)\/\/ template:([a-zA-Z0-9_]+)/g;
    const match = regex.exec(line);
    if (match) {
      if (match[2] === "end") {
        assert.strictEqual(stateStack[stateStack.length - 1] === tempBody || stateStack[stateStack.length - 1] === tempHeader, true);
        // pop
        stateStack.pop();
        if (stateStack[stateStack.length - 1] === tempHeader) { stateStack.pop(); }
        assert.strictEqual(stateStack[stateStack.length - 1], tempOutside);
        // flush
        for (const elem of lines) {
          outBuffer += `${indentToUse}${elem}\n`;
        }
      } else {
        assert.strictEqual(stateStack[stateStack.length - 1] === tempOutside, true);
        stateStack.push(tempHeader);
        tempId = match[2];
        const indents = Math.floor(match[1].length / indent);
        for (let i = 0; i < indents; i++) {
          indentToUse += indentSpaces;
        }
      }
      outBuffer += line + "\n";
    } else {
      if (stateStack[stateStack.length - 1] === tempHeader) {
        stateStack.push(tempBody);
      } else if (stateStack[stateStack.length - 1] === tempBody) {
        if (tempId !== temp) {
          outBuffer += line + "\n";
        }
      } else if (stateStack[stateStack.length - 1] === tempOutside) {
        outBuffer += line + "\n";
      } else {
        throw new Error(`Unknown state ${stateStack[stateStack.length - 1]}`);
      }
    }
  });
  lr.on("close", () => {
    console.log("success");
    fs.writeFileSync(fp, outBuffer);
  });
}

const fpConfigts = path.join("armyio-laya", "src", "Config.ts");

const obj = JSON.parse(fs.readFileSync(path.join("armyio-laya", "bin", "resources", "unity-exported", "formation.lh")).toString());
const cubes = obj.child[0].child;
const replaceTexts = [];
for (const elem of cubes) {
  replaceTexts.push("[" + (0 - elem.customProps.translate[0]) + ", " + elem.customProps.translate[2] + "],");
}
replaceTemplate(fpConfigts, "PLAYER_SOLDIERS_FORMATION", replaceTexts);
```
