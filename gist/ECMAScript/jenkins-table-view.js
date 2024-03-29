const axios = require("axios")
const fs = require("fs")
const path = require("path")

const fpAll = path.join(__dirname, "all-jenkins.csv")

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
    "CURRENTBRANCH",
    "DebugOrRelease",
    "ISDEBUG",
    "CURRENTVERSION",
    "CHANNEL",
    "DOUBLECHANNEL",
    "CURRENTCHANNEL",
    "IS_NHP_ENC_AB",
    "ISBUNDLE",
    "ISONLYBUILDLUA",
    "ISFIRMAPK",
    "ISUPLOADUPX",
    "ISEXPORTPORJECT",
    "ISBUILD32",
    "JENKINS_ROT",
]

let max = 1200
let min = 1

if (process.argv.length === 3) {
    try {
        max = parseInt(process.argv[2], 10)
    } catch (error) {
        console.log("node jenkins-table-view 5000")
        process.exit(1)
    }
} else {
    console.log("node jenkins-table-view 5000")
    process.exit(1)
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
    const existsMap = {}
    if (fs.existsSync(fpAll)) {
        const localAll = fs.readFileSync(fpAll).toString().split("\n")
        for (const lineRaw of localAll) {
            if (lineRaw.trim().length === 0) {
                continue
            }
            const parts = lineRaw.trim().split(",")
            if (parts.length !== cols.length) {
                continue
            }
            if (parts[0] === "JOB_NUMBER") {
                continue
            }
            if (parts[1] === "NO_JOB") {
                continue
            }
            const obj = {}
            for (let i = 0; i < cols.length; i++) {
                obj[cols[i]] = parts[i]
            }
            all.push(obj)
            existsMap[parts[0]] = true
        }
    }

    for (let build = min; build <= max; build++) {
        if (existsMap[build.toString()]) {
            console.log(`Skip requested build ${build}`)
            continue
        }
        const url = `http://192.168.30.6:8080/job/barrett_new/${build}/api/json`
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
            console.log(`\u001B[31mRequest failed. Build: ${build}\u001B[0m`)
            all.push({
                JOB_NUMBER: build,
                USER: "NO_JOB"
            })
        }
    }
    all.sort((a, b) => {
        return a.JOB_NUMBER - b.JOB_NUMBER
    })
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
    fs.writeFileSync(fpAll, sb)
}

exec()
