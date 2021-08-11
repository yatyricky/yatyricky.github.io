let fs = require("fs")

let all = fs.readFileSync("1.txt").toString().split("\n")
let map = {}
for (const line of all) {
    map[line] = 1
}
let keys = Object.keys(map)
let sorted = keys.sort()
fs.writeFileSync("2.txt", sorted.join("\n"))