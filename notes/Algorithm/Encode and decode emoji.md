``` javascript
/**
 * 将 emojis 转为 \ud830... emojis
 * @param input {string}
 * @return {string}
 */
encodeEmoji = function (input) {
    let exp = /[\uD800-\uDBFF][\uDC00-\uDFFF]/g
    let mstr = input.replace(exp, function (word) {
        let result = ''
        for (let i = 0; i < word.length; i++) {
            result += '\\u' + word.charCodeAt(i).toString(16)
        }
        return result
    })

    // TODO 去掉尾部不完整的 emoji /[\uD800-\uDBFF]?(\\|\\u|\\u\w{0-3})$/

    return mstr
}

/**
 * 解析转化成 \ud83c... 的 emojis
 * @param input {string}
 * @return {string}
 */
decodeEmoji = function (input) {
    let mstr = input.replace(/\\u([\da-f]{1,4})/g, function (word, code) {
        return String.fromCharCode(parseInt(code, 16))
    })
    return mstr
}
```