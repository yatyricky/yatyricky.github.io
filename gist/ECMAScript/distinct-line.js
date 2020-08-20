const fs = require("fs")

const lines = fs.readFileSync("gist/input.txt").toString().split("\n")
const map = {}
for (const l of lines) {
    map[l] = 1
}
fs.writeFileSync("gist/output", Object.keys(map).join("\n"))