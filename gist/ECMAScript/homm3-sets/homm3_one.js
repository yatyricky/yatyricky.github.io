const fs = require("fs")

const AllSets = JSON.parse( fs.readFileSync("all-combs.json").toString())

let stack = [];
let occupied = {};

const setNames = JSON.parse(fs.readFileSync("all-sets.json").toString())

for (const e of setNames) {
    occupied[e]=1
}

function hasUnused() {
    for (const art in occupied) {
        if (occupied.hasOwnProperty(art)) {
            if (occupied[art] === 1) {
                return true
            }
        }
    }
    return false
}

function canEquip(item) {
    let hasSlot = true;
    for (let i = 0; i < item.length && hasSlot; i++) {
        const part = item[i];
        if (occupied[part] < 1) {
            hasSlot = false
        }
    }
    return hasSlot;
}

function equip(item) {
    for (const part of item) {
        occupied[part] -= 1;
    }
}

function unequip(item) {
    for (const part of item) {
        occupied[part] += 1;
    }
}

let allCombinations = []

let output = []

function printStack() {
    let len = stack.length
    if (output[len] === undefined) {
        output[len] = []
    }
    output[len].push(stack.map(e=>e.join("/")).join(" + "))
}

function begin(idx) {
    for (let i = idx; i < AllSets.length; i++) {
        const e = AllSets[i];
        if (canEquip(e)) {
            stack.push(e);
            equip(e)
            begin(i + 1);
        }
    }
    if (stack.length > 0 && !hasUnused()) {
        printStack()
    }
    let e = stack.pop();
    if (e) {
        unequip(e)
    }
}

begin(0);

(function() {
    for (let i = 0; i < output.length; i++) {
        if (output[i] !== undefined) {
            console.log(output[i].join("\n"))
            return
        }
    }
})()

// for (let i = 0; i < AllSets.length; i++) {
//     const s = AllSets[i];
//     const find = allCombinations.filter(e => e.indexOf(s.Name) !== -1)
//     console.log(s.Name + ":")
//     console.log(find.map(e=>e.join(" / ")).join("\n"))
//     console.log()
// }
