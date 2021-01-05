const axios = require("axios")
const fs = require("fs")
const path = require("path")

let max = 1200
let min = 1210

if (process.argv.length === 3) {
    try {
        const tokens = process.argv[2].split("-")
        min = parseInt(tokens[0], 10)
        max = parseInt(tokens[1], 10)
    } catch (error) {
        console.log("node jenkins-table-view 1-1000")
    }
}

function g(obj, dft, ...stringLiterals) {
    let i = 0;
    while (obj !== undefined && obj !== null && i < stringLiterals.length) {
        obj = obj[stringLiterals[i++]];
    }
    if (obj === undefined || obj === null) {
        return dft
    } else
    {
        return obj
    }
}

function arr2obj(arr, key) {
    const obj = {}
    for (const e of arr) {
        obj[e[key] || "UNKNOWN"] = e
    }
    return obj
}

async function exec() {
    const all = []
    for (let build = min; build <= max; build++) {
        const url = `http://192.168.199.180:8080/pack/app/job/barrett/${build}/api/json`
        let resp
        try {
            resp = await axios.default.get(url, {
                auth: {
                    username: 'sunshilong',
                    password: '113870b09a326e83242323348118faf21b'
                }
            })
            console.log(`request complete ${build}`)
            const data = resp.data
            const time = data.timestamp || 0
            const actions = {}
            for (const action of g(data, [], "actions")) {
                actions[action._class] = action
            }
            const userCauses = arr2obj(g(actions, [], "hudson.model.CauseAction", "causes"), "_class")
            const user = g(userCauses, "NO_USER", "hudson.model.Cause$UserIdCause", "userId")
            const commitId = g(actions, "", "hudson.plugins.git.util.BuildData", "lastBuiltRevision", "SHA1")
            const params = g(actions, [], "hudson.model.ParametersAction", "parameters")
            let paramObj = {
                JOB_NUMBER: build,
                COMMIT_ID: commitId,
                USER: user,
                TIMESTAMP: new Date(time),
            }
            for (let i = 0; i < params.length; i++) {
                const param = params[i];
                let val = param.value
                if (param.name === "MODIFY_LOG") {
                    val = val.replace(/\n/g, " ")
                }
                paramObj[param.name || "UNKNOWN"] = val
            }
            all.push(paramObj)
        } catch (error) {
            all.push({
                JOB_NUMBER: build,
                USER: "NO_JOB"
            })
        }
    }
    all.sort((a, b) => {
        return a.JOB_NUMBER - b.JOB_NUMBER
    })
    const cols = [
        "JOB_NUMBER",
        "USER",
        "TIMESTAMP",
        "COMMIT_ID",
        "BRANCH",
        "PLATFORM",
        "MODE",
        "VERSION",
        "MODIFY_LOG",
        "BUILD_ACTION",
        "PACKAGE_MODE",
        "IPA_METHOD",
        "BUILD_CODE",
        "ALIAS",
        "PATCH_PLATFORM_MODE",
        "PATCH_VERSION",
        "PATCH_COMMIT",
    ]
    let sb = cols.join(",") + "\n"
    for (let i = 0; i < all.length; i++) {
        const e = all[i];
        for (let j = 0; j < cols.length; j++) {
            const key = cols[j];
            sb = sb + (e[key] || "UNDEFINED")
            if (j < cols.length - 1) {
                sb = sb + ","
            }
        }
        sb = sb + "\n"
    }
    fs.writeFileSync(path.join(__dirname, "all-jenkins.csv"), sb)
}

exec()
