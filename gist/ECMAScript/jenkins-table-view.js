const axios = require("axios")
const fs = require("fs")

async function exec() {
    const all = []
    for (let build = 1285; build > 0; build--) {
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
            const params = resp.data.actions[0].parameters
            const commitId = resp.data.actions[2].lastBuiltRevision.SHA1
            let paramObj = {
                JOB_NUMBER: build,
                COMMIT_ID: commitId
            }
            for (let i = 0; i < params.length; i++) {
                const param = params[i];
                paramObj[param.name || "UNKNOWN"] = param.value
            }
            all.push(paramObj)
        } catch (error) {
            console.log(error)
        }
    }
    all.sort((a, b) => {
        return a.JOB_NUMBER - b.JOB_NUMBER
    })
    let sb = "JOB_NUMBER,COMMIT_ID,BRANCH,PLATFORM,MODE,VERSION,MODIFY_LOG,BUILD_ACTION,PACKAGE_MODE,IPA_METHOD,BUILD_CODE,ALIAS,PATCH_PLATFORM_MODE,PATCH_VERSION,PATCH_COMMIT\n"
    for (let i = 0; i < all.length; i++) {
        const e = all[i];
        sb = sb + `${e.JOB_NUMBER},${e.COMMIT_ID},${e.BRANCH},${e.PLATFORM},${e.MODE},${e.VERSION},${e.MODIFY_LOG},${e.BUILD_ACTION},${e.PACKAGE_MODE},${e.IPA_METHOD},${e.BUILD_CODE},${e.ALIAS},${e.PATCH_PLATFORM_MODE},${e.PATCH_VERSION},${e.PATCH_COMMIT}\n`;
    }
    fs.writeFileSync("jenkins-all.csv", sb)
}

exec()
