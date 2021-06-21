const fs = require("fs")

let print = console.log

function map2s(obj) {
    obj = obj || {}
    let keys = Object.keys(obj).map(e => parseInt(e, 10))
    keys.sort()
    return keys.map(k => `${k}=${obj[k.toString()]}`).join(",")
}

let allLines = fs.readFileSync(__dirname + "/log.txt").toString().split("\n")

let template = {
    heroes: {
        [111]: 1,
        // ...
    },
    bags: {
        [0]: {
            stackables: {
                [1]: 100,
                [2]: 5000
            },
            nonStackables: {
                [10013]: {
                    configId: 21515,
                    star: 1
                }
            },
        }
    },
    collections: {
        [111]: 1
    }
}

// function interestBagToString(obj) {
//     return `${map2s(obj.stackables)} `
// }

// function interestToString(int) {
//     return `heroes:${map2s(int.heroes)} bags:`
// }

function opSubDictNumber(a, b) {
    let r = JSON.parse(JSON.stringify(a))
    for (const key in b) {
        if (a.hasOwnProperty(key)) {
            let res = r[key] - b[key]
            if (res === 0) {
                delete r[key]
            } else {
                r[key] = res
            }
        } else {
            r[key] = -b[key]
        }
    }
    return r
}

function opSubDictItem(a, b) {
    let r = JSON.parse(JSON.stringify(a))
    for (const key in b) {
        if (a.hasOwnProperty(key)) {
            let res = r[key].star - b[key].star
            if (res === 0) {
                delete r[key]
            } else {
                r[key].star = res
            }
        } else {
            r[key] = {
                configId: b[key].configId,
                star: -b[key].star,
                amount: -1
            }
        }
    }
    return r
}

function diffInterest(a, b) {
    let r = {}
    r.heroes = opSubDictNumber(a.heroes, b.heroes)
    r.bags = {}
    for (let bagIndex = 0; bagIndex < 4; bagIndex++) {
        const key = bagIndex.toString(10)
        const aBag = a.bags[key] || { stackables: {}, nonStackables: {} }
        const bBag = b.bags[key] || { stackables: {}, nonStackables: {} }
        r.bags[key] = {
            stackables: opSubDictNumber(aBag.stackables, bBag.stackables),
            nonStackables: opSubDictItem(aBag.nonStackables, bBag.nonStackables)
        }
    }
    r.collections = opSubDictNumber(a.collections, b.collections)
    return r
}

function convertInterest(data) {
    let r = {}
    let heroes = {}
    let levels = (data.heroData || {}).levels || {}
    for (const key in levels) {
        heroes[key] = levels[key].value
    }
    r.heroes = heroes
    let bags = {}
    let dBags = (data.bagInfo || {}).bags || {}
    for (let i = 0; i < 4; i++) {
        let idx = i.toString()
        let items = (dBags[idx] || {}).items || []
        let stackables = {}
        let nonStackables = {}
        for (const item of items) {
            if (item.instanceId === 0) {
                stackables[item.configId.toString()] = item.amount
            } else {
                nonStackables[item.instanceId.toString()] = {
                    configId: item.configId,
                    star: item.star
                }
            }
        }
        bags[idx] = { stackables, nonStackables }
    }
    r.bags = bags
    let collections = {}
    let parts = (data.collections || {}).parts || {}
    for (const key in parts) {
        collections[key] = parts[key].value
    }
    r.collections = collections
    return r
}

let prev = null
for (const rawLine of allLines) {
    let line = rawLine.trim()
    if (!line.startsWith(`{"level":"info"`)) {
        continue
    }
    let lineObj = JSON.parse(line)
    let msg = lineObj.msg
    let msgParts = msg.split(" ")
    let protocol = msgParts[0]
    let userId = msgParts[1]
    let dataString = msgParts.slice(2).join(" ").substring(5).replace(/\\"/g, "\"")
    let data = JSON.parse(dataString)
    let int = convertInterest(data)
    let diff
    if (prev !== null) {
        diff = diffInterest(prev, int)
    } else {
        diff = ""
    }
    print(`${lineObj.t} heroes:${map2s(int.heroes)} diff:${JSON.stringify(diff)}`)
    prev = int
}
