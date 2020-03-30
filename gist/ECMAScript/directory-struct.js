const fs = require("fs");
const path = require("path");
const crypto = require("crypto");

const dp2 = "C:\\repositories\\World of Warcraft\\_classic_\\WTF\\Account\\YATYRICKY\\木喉要塞\\洛科林丶雷酒";
const dp = "C:\\repositories\\World of Warcraft\\_classic_\\WTF\\Account\\YATYRICKY\\木喉要塞\\漫烟特大剑";

/**
 * @typedef IDirectoryHash
 * @type {{[name: string]: string | IDirectoryHash}}
 */

/**
 * @param {fs.PathLike} dirPath
 * @returns {IDirectoryHash}
 */
function getDirectoryHash(dirPath) {
    if (!fs.existsSync(dirPath) || !fs.statSync(dirPath).isDirectory()) {
        return null;
    }
    /**
     * @type {IDirectoryHash}
     */
    const ret = {};
    for (const file of fs.readdirSync(dirPath)) {
        const fullPath = path.join(dirPath, file);
        if (fs.statSync(fullPath).isDirectory()) {
            ret[file] = getDirectoryHash(fullPath);
        } else {
            ret[file] = crypto.createHash("sha1").update(fs.readFileSync(fullPath)).digest("hex");
        }
    }
    return ret;
}

/**
 * @typedef IDirectoryHashCompare
 * @type {{[name: string]: "left" | "right" | "diff" | IDirectoryHashCompare}}
 */

/**
 * 
 * @param {IDirectoryHash} left 
 * @param {IDirectoryHash} right 
 * @returns {IDirectoryHashCompare}
 */
function compareDirectoryHashes(left, right) {
    const lfiles = Object.keys(left);
    const rfiles = Object.keys(right);
    /**
     * @type {string[]}
     */
    const intersect = [];
    /**
     * @type {IDirectoryHashCompare}
     */
    const ret = {};
    for (const lfile of lfiles) {
        if (rfiles.indexOf(lfile) === -1) {
            ret[lfile] = "left";
        } else {
            intersect.push(lfile);
        }
    }
    for (const rfile of rfiles) {
        if (lfiles.indexOf(rfile) === -1) {
            ret[rfile] = "right";
        } else {
            intersect.push(rfile);
        }
    }
    for (const file of intersect) {
        const l = left[file];
        const r = right[file];
        if (typeof(l) !== typeof(r)) {
            ret[file] = "diff";
        } else if (typeof(l) === "string") {
            if (l !== r) {
                ret[file] = "diff";
            }
        } else {
            const childrenDiff = compareDirectoryHashes(l, r);
            if (childrenDiff !== null) {
                ret[file] = childrenDiff;
            }
        }
    }
    if (Object.keys(ret).length > 0) {
        return ret;
    } else {
        return null;
    }
}

/**
 * 
 * @param {fs.PathLike} leftPath 
 * @param {fs.PathLike} rightPath 
 * @returns {IDirectoryHashCompare}
 */
function compareDirectory(leftPath, rightPath) {
    const left = getDirectoryHash(leftPath);
    const right = getDirectoryHash(rightPath);
    return compareDirectoryHashes(left, right);
}

const res = compareDirectory(dp, dp2);
const a = 1;
