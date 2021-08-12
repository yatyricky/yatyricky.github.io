let fs = require("fs")

let all = fs.readFileSync("1.log").toString().split("\n")
let map = {}
for (const line of all) {
    map[line.trim()] = 1
}
let keys = Object.keys(map)
let sorted = keys.sort()
fs.writeFileSync("2.log", sorted.join("\n"))