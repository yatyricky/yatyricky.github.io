function combination(list, n) {
    // init pointers
    const pointers = new Array(n)
    for (let i = 0; i < n; i++) {
        pointers[i] = i
    }
    // start of the main logic
    const result = []
    while (true) {
        // yield one combination based on current pointers
        const oneCombination = []
        for (let i = 0; i < n; i++) {
            const pointer = pointers[i]
            oneCombination.push(list[pointer])
        }
        result.push(oneCombination)
        // if the first pointer can't move anymore
        // all combinations are exhausted
        if (pointers[0] >= list.length - n) {
            break
        }
        // move pointer
        for (let i = n - 1; i >= 0; i--) {
            if (pointers[i] < list.length - (n - i)) {
                pointers[i]++
                // if one pointer is moved, align all subsequent pointers next to it
                for (let j = i + 1; j < n; j++) {
                    pointers[j] = pointers[i] + j - i
                }
                break
            }
        }
    }
    return result
}

const set = [1,2,3,4,5]

console.log(combination(set, 3))
