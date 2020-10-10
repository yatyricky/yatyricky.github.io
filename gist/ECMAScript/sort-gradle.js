const fs = require("fs")

const ctx = fs.readFileSync("dependencies").toString()

/**
 * 
 * @param {string} str 
 * @returns {[string, string, boolean]}
 */
function getTrimmedAndPayload(str) {
    const trimmed = str.trim()
    let payload
    let isCommented
    if (trimmed.startsWith("//")) {
        payload = trimmed.replace("//", "").trim()
        isCommented = true
    } else {
        payload = trimmed
        isCommented = false
    }
    return [trimmed, payload, isCommented]
}

const lines = ctx.split("\n").map(e => {
    let [trimmed, payload, comment] = getTrimmedAndPayload(e)
    if (payload.length === 0) {
        return ""
    }
    if (!payload.startsWith("implementation")) {
        return ""
    }
    // payload = payload.replace("implementation", "")
    // const tailCommentIndex = payload.indexOf("//")
    // if (tailCommentIndex >= 0) {
    //     payload = payload.substring(0, tailCommentIndex)
    // }
    // payload = payload.replace(/ /g, "")
    if (comment) {
        return `//    ${payload}`
    } else {
        return `    ${payload}`
    }
}).filter(e => e.length > 0)

const sorted = lines.sort((a, b) => {
    const [ta, pa, ca] = getTrimmedAndPayload(a)
    const [tb, pb, cb] = getTrimmedAndPayload(b)
    return pa.localeCompare(pb)
})

fs.writeFileSync("dependencies.sorted", sorted.join("\n"))