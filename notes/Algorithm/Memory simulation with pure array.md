``` js
const MAX_INSTANCES = 65535
let freed = 0
let count = 0
let table = []

function alloc() {
    let ref = freed
    if (ref != 0) {
        freed = table[ref]
    } else {
        count = count + 1
        ref = count
    }
    if (ref > MAX_INSTANCES) {
        return 0
    }
    table[ref] = -1
    return ref
}

function free(ref) {
    if (ref == 0) {
        return
    } else if (table[ref] != -1) {
        return
    }
    table[ref] = freed
    freed = ref
}
```