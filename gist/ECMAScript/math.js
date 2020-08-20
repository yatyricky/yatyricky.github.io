function mrandom(stdDev) {
    var half = stdDev * 0.5
    return (Math.random() * half  + Math.random() * half) - half
}

function min(stdDev) {
    var half = stdDev * 0.5
    return (0 * half  + 0 * half) - half
}

function max(stdDev) {
    var half = stdDev * 0.5
    return (1 * half  + 1 * half) - half
}

var m = 4

for (let i = 0; i < 10; i++) {
    console.log(m, mrandom(m), min(m), max(m))
}