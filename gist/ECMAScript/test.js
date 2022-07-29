const fs = require("fs")
const path = require("path")

let dir = fs.readdirSync("./homm3-sets")

for (const file of dir) {
    var f = path.join("./homm3-sets", file) //?
    if (fs.statSync(f).isFile()) {
        console.log(f)
    }
}
