const sample = 10000
const virus = 1000
const perTube = 20

const iterations = 10000

function getOne(array) {
    let len = array.length
    let idx = Math.floor(Math.random() * len)
    let ret = array[idx]
    array[idx] = array[len - 1]
    array.pop()
    return ret
}

function testOne() {
    // distribution
    let population = []
    for (let i = 0; i < virus; i++) {
        population.push(1)
    }
    for (let i = virus; i < sample - 1; i++) {
        population.push(0)
    }
    // you
    population.push(2)

    // do test
    let tubes = []
    let myTube
    while (population.length > 0) {
        let tube = { result: [], positive: false }
        for (let i = 0; i < perTube; i++) {
            let sample = getOne(population)
            if (sample === 1) {
                tube.positive = true
            }
            if (sample === 2) {
                myTube = tube
            }
            tube.result.push(sample)
        }
        tubes.push(tube)
    }

    return myTube.positive
}

function runTest()
{
    let bustedCount = 0
    for (let i = 0; i < iterations; i++) {
        if (testOne()) {
            bustedCount++
        }
    }
    return bustedCount / iterations
}

let prob = runTest()
console.log(prob)