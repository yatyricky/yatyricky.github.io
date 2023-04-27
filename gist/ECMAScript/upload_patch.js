let child_process = require("child_process")

const WORKSPACE = "C:/Users/yatyr/workspace/barrett-client"
const UNITY3D_EXE_PATH = "\"C:/Program Files/Unity/Hub/Editor/2020.3.41f1/Editor/Unity.exe\""
const LOG_FILE = "log1.log"
const LOG_FILE_2 = "log2.log"
const UNITY3D_UPLOAD_METHOD = "UploadPackage.UploadForShell"
const UNITY3D_UPLOAD_START_BUILD = "UploadPackage.StartUploadFileForJenkins"

function cmd(instruction, options) {
    let out = child_process.execSync(instruction, options)
    let str = out.toString("utf8")
    return str.trim()
}

// const prompt = require('prompt-sync')();

// const name = prompt('What is your name?');
// console.log(`Hey there ${name} ${process.argv[2]}`);

let args = process.argv.slice(2)

let CHANNEL = args[0]
let PLATFORM = "android"
let VERSION = args[1]
let BUILD_CODE = ""
let BUILD_NUMBER = args[2]
let GIT_COMMIT = cmd(`git -C "${WORKSPACE}" rev-parse HEAD`)
let ISBUNDLE = "true"
let ISONLYBUILDLUA = "true"
let DOUBLECHANNEL = ""
let ISDEBUG = "true"
let CURRENTBRANCH = `origin/${cmd(`git -C "${WORKSPACE}" rev-parse --abbrev-ref HEAD`)}`
let IS_NHP_ENC_AB = ""

let config = {
    channel: CHANNEL,
    platform: PLATFORM,
    version: VERSION,
    buildCode: BUILD_CODE,
    build: BUILD_NUMBER,
    commit: GIT_COMMIT,
    isBuild: ISBUNDLE,
    isOnlyBuildLua: ISONLYBUILDLUA,
    doubleChannel: DOUBLECHANNEL,
    isDebug: ISDEBUG,
    currentBranch: CURRENTBRANCH,
    isNHPEncAB: IS_NHP_ENC_AB
}

let CONFIG = JSON.stringify(config)

console.log(CONFIG)

cmd(`${UNITY3D_EXE_PATH} -logFile ${LOG_FILE} -quit -batchmode -projectPath ./client -executeMethod ${UNITY3D_UPLOAD_METHOD} config:${CONFIG}`, { cwd: WORKSPACE })
cmd(`${UNITY3D_EXE_PATH} -logFile ${LOG_FILE_2} -quit -batchmode -projectPath ./client -executeMethod ${UNITY3D_UPLOAD_START_BUILD} config:${CONFIG}`, { cwd: WORKSPACE })
