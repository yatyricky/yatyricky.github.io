let fs = require("fs")

let forbidChars = [
    [new RegExp("\\<", "g"), "LT"],
    [new RegExp("\\>", "g"), "GT"],
    [new RegExp(":", "g"), "SC"],
    [new RegExp("\"", "g"), "DQ"],
    [new RegExp("/", "g"), "FS"],
    [new RegExp("\\\\", "g"), "BS"],
    [new RegExp("\\|", "g"), "VB"],
    [new RegExp("\\?", "g"), "QM"],
    [new RegExp("\\*", "g"), "AR"],
    [new RegExp("\\^", "g"), "SA"],
]

let allWords = fs.readFileSync(__dirname + "/" + "file_names.txt").toString().split("\n").map(e => e.trim())
for (const key of allWords) {
    let newKey = key
    if (newKey.startsWith(".")) {
        newKey = "EPRE" + newKey.slice(1)
    }
    if (newKey.endsWith(".")) {
        newKey = newKey.substring(0, newKey.length - 1) + "EPRE"
    }
    if (newKey.endsWith(" ")) {
        newKey = newKey.substring(0, newKey.length - 1) + "EWSE"
    }
    for (const rep of forbidChars) {
        newKey = newKey.replace(rep[0], `E${rep[1]}E`)
    }
    if (newKey !== key) {
        console.log(newKey)
    }
}
