// const path = require("path")

// const dir = "D:/Projects/barrett-client"

// const combined = path.join(dir, "client")

// console.log(combined)

console.log(process.platform)

const child_process = require("child_process")

console.log(child_process.execSync("echo blah").toString("utf8"))