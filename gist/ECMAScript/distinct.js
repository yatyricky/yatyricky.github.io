let fs = require("fs")

let all = fs.readFileSync("1.log").toString().split("\n")
let map = {}
for (const line of all) {
    map[line.trim()] = 1
}
let keys = Object.keys(map)
let sorted = keys.sort()
let filtered = sorted.filter(e => e.startsWith("127.0.0.1"))
fs.writeFileSync("2.log", filtered.join("\n"))