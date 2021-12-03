const fs = require("fs")

const AllSets = [
    {
        Name: "海洋之帽",
        Parts: [
            ["Helmet", "航海家之帽"],
            ["Necklace", "海神项链"],
        ],
    },
    // {
    //     Name: "海军司令",
    //     Parts: [
    //         ["Helmet", "航海家之帽"],
    //         ["Necklace", "海神项链"],
    //         ["Boots", "水神靴"],
    //     ],
    // },
    {
        Name: "天使联盟",
        Parts: [
            ["Helmet", "神谕之冠"],
            ["Armor", "神奇战甲"],
            ["Weapon", "先知剑"],
            ["Shield", "狮王盾"],
            ["Boots", "圣靴"],
            ["Necklace", "天使项链"],
        ],
    },
    {
        Name: "诅咒铠甲",
        Parts: [
            ["Helmet", "骷髅冠"],
            ["Armor", "骨质胸甲"],
            ["Weapon", "黑魔剑"],
            ["Shield", "亡灵盾"],
        ],
    },
    {
        Name: "幻影神弓",
        Parts: [
            ["Trinkets", "天羽箭", "神兽之鬃", "树精灵之弓"],
        ],
    },
    {
        Name: "鬼王披风",
        Parts: [
            ["Boots", "死神靴"],
            ["Cloaks", "吸血鬼披风"],
            ["Necklace", "亡灵护身符"],
        ],
    },
    {
        Name: "丰收之角",
        Parts: [
            ["Cloaks", "水晶披风"],
            ["Rings", "宝石戒指", "硫磺指环"],
            ["Trinkets", "水银瓶"],
        ],
    },
    {
        Name: "神圣血瓶",
        Parts: [
            ["Rings", "活力之戒", "生命之戒"],
            ["Trinkets", "活力圣瓶"],
        ],
    },
    {
        Name: "龙王神力",
        Parts: [
            ["Helmet", "龙牙冠"],
            ["Armor", "龙甲"],
            ["Weapon", "赤龙剑"],
            ["Shield", "龙盾"],
            ["Boots", "龙骨胫甲"],
            ["Cloaks", "龙翼袍"],
            ["Necklace", "龙牙项链"],
            ["Rings", "龙眼戒", "龙眼指环"],
        ],
    },
    {
        Name: "法师之戒",
        Parts: [
            ["Cloaks", "魔法披风"],
            ["Necklace", "魔力项圈"],
            ["Rings", "魔戒"],
        ],
    },
    {
        Name: "天赐神兵",
        Parts: [
            ["Trinkets", "天赐神首", "天赐神躯", "天赐神臂", "天赐神胯", "天赐神足"],
        ],
    },
    {
        Name: "泰坦之箭",
        Parts: [
            ["Helmet", "雷神之盔"],
            ["Armor", "泰坦战甲"],
            ["Weapon", "泰坦之剑"],
            ["Shield", "守护神之盾"],
        ],
    },
    {
        Name: "魔力源泉",
        Parts: [
            ["Trinkets", "魔力护符", "魔法护符", "魔力球"],
        ],
    },
    // {
    //     Name: "丛林猎装",
    //     Parts: [
    //         ["Helmet", "神兽之冠"],
    //         ["Armor", "藤木甲"],
    //         ["Weapon", "人马战斧"],
    //         ["Shield", "矮人王盾"],
    //     ],
    // },
    // {
    //     Name: "沼泽装束",
    //     Parts: [
    //         ["Helmet", "混沌之冠"],
    //         ["Armor", "大蛇神胸甲"],
    //         ["Weapon", "狼人连枷"],
    //         ["Shield", "狼人王盾"],
    //     ],
    // },
    {
        Name: "Ironfist of the Ogre",
        Parts: [
            ["Helmet", "智慧之冠"],
            ["Armor", "巨人战甲"],
            ["Weapon", "恶魔之棒"],
            ["Shield", "狂魔盾"],
        ],
    },
    // {
    //     Name: "地狱战甲",
    //     Parts: [
    //         ["Helmet", "地狱王冠"],
    //         ["Armor", "黄金甲"],
    //         ["Weapon", "火神剑"],
    //         ["Shield", "邪盾"],
    //     ],
    // },
    // {
    //     Name: "抗魔",
    //     Parts: [
    //         ["Boots", "抗魔靴"],
    //         ["Cloaks", "抗魔披风"],
    //         ["Necklace", "抗魔链"],
    //     ],
    // },
    {
        Name: "Diplomat's Cloak",
        Parts: [
            ["Cloaks", "大使勋带"],
            ["Necklace", "政治家勋章"],
            ["Rings", "礼仪之戒"],
        ],
    },
    // {
    //     Name: "速度",
    //     Parts: [
    //         ["Cloaks", "急速披风"],
    //         ["Necklace", "急速项链"],
    //         ["Rings", "旅行者之戒"],
    //     ],
    // },
    // {
    //     Name: "鹰眼",
    //     Parts: [
    //         ["Trinkets", "神目鸟", "火眼人", "真理徽章"],
    //     ],
    // },
    // {
    //     Name: "幸运",
    //     Parts: [
    //         ["Trinkets", "幸运三叶草", "预言卡", "幸运鸟"],
    //     ],
    // },
    // {
    //     Name: "士气",
    //     Parts: [
    //         ["Trinkets", "勇气勋章", "勇士勋章", "勇士令"],
    //     ],
    // },
    // {
    //     Name: "侦察",
    //     Parts: [
    //         ["Trinkets", "窥镜", "望远镜"],
    //     ],
    // },
    // {
    //     Name: "资源",
    //     Parts: [
    //         ["Trinkets", "矿石车", "木材车", "黄金包", "黄金袋", "黄金囊"],
    //     ],
    // },
    // {
    //     Name: "魔力",
    //     Parts: [
    //         ["Trinkets", "水灵球","土灵球","火灵球","气灵球","毁灭之球"],
    //     ],
    // },
    // {
    //     Name: "魔法",
    //     Parts: [
    //         ["Helmet", "魔法师之帽"],
    //         ["Trinkets", "水系魔法书","土系魔法书","火系魔法书","气系魔法书","永恒之球"],
    //     ],
    // },
    // {
    //     Name: "禁魔",
    //     Parts: [
    //         ["Cloaks", "禁魔披风"],
    //         ["Trinkets", "禁魔球"],
    //     ],
    // },
    // {
    //     Name: "旅行",
    //     Parts: [
    //         ["Boots", "神行靴"],
    //         ["Cloaks", "炽天之翼"],
    //         ["Rings", "骑士手套"],
    //     ],
    // },
    {
        Name: "Golden Goose",
        Parts: [
            ["Trinkets", "黄金包", "黄金袋", "黄金囊"],
        ],
    }
]

let stack = [];
let occupied = {
    Helmet: 1,
    Armor: 1,
    Weapon: 1,
    Shield: 1,
    Boots: 1,
    Cloaks: 1,
    Necklace: 1,
    Rings: 2,
    Trinkets: 5,
};

function canEquip(item) {
    let hasSlot = true;
    for (let i = 0; i < item.Parts.length && hasSlot; i++) {
        const part = item.Parts[i];
        if (occupied[part[0]] < part.length - 1) {
            hasSlot = false
        }
    }
    return hasSlot;
}

function equip(item) {
    for (const part of item.Parts) {
        occupied[part[0]] -= part.length - 1;
    }
}

function unequip(item) {
    for (const part of item.Parts) {
        occupied[part[0]] += part.length - 1;
    }
}

let allCombinations = []

function printStack() {
    let slots = {
        Helmet: [],
        Armor: [],
        Weapon: [],
        Shield: [],
        Boots: [],
        Cloaks: [],
        Necklace: [],
        Rings: [],
        Trinkets: [],
    };
    let names = []
    for (const item of stack) {
        names.push(item.Name)
        for (const part of item.Parts) {
            slots[part[0]].push(...part.slice(1))
        }
    }
    allCombinations.push(names)
    for (let i = slots.Rings.length; i < 2; i++) {
        slots.Rings.push("")
    }
    for (let i = slots.Trinkets.length; i < 5; i++) {
        slots.Trinkets.push("")
    }
    let sb = names.join("/")
    for (const slot of ["Helmet", "Armor", "Weapon", "Shield", "Boots", "Cloaks", "Necklace", "Rings", "Trinkets"]) {
        sb += "," + slots[slot].join(",")
    }
    // console.log(sb)
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
    if (stack.length > 0) {
        printStack()
    }
    let e = stack.pop();
    if (e) {
        unequip(e)
    }
}

begin(0);

function exportToNext() {
    fs.writeFileSync("all-sets.json", JSON.stringify(AllSets.map(e=>e.Name), null, 2))
    fs.writeFileSync("all-combs.json", JSON.stringify(allCombinations, null, 2))
}

exportToNext()

// for (let i = 0; i < AllSets.length; i++) {
//     const s = AllSets[i];
//     const find = allCombinations.filter(e => e.indexOf(s.Name) !== -1)
//     console.log(s.Name + ":")
//     console.log(find.map(e=>e.join(" / ")).join("\n"))
//     console.log()
// }
