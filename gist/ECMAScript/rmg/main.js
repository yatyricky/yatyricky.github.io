const fs = require("fs")
const path = require("path")

const allTemplates = []
for (const file of fs.readdirSync("templates")) {
    const obj = JSON.parse(fs.readFileSync(path.join("templates", file)).toString())
    console.log(obj)
}