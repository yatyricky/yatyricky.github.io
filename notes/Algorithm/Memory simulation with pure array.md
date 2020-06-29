``` js
const MAX_INSTANCES = 3
let freed = -1
let count = 0
let table = []

function alloc() {
    let ref = freed
    if (ref !== -1) {
        freed = table[ref]
    } else {
        ref = count++
    }
    if (ref > MAX_INSTANCES) {
        // return 0
    }
    table[ref] = -2
    return ref
}

function free(ref) {
    if (ref < 0) {
        console.log("ref -1")
        return
    } else if (table[ref] !== -2) {
        console.log("already freed")
        return
    }
    table[ref] = freed
    freed = ref
}
```

Sample ts class

``` typescript
export default class vec2 {

    private static _freed: number = 0;
    private static _count: number = 0;
    private static _table: number[] = [];
    private static _insts: vec2[] = [];

    public static get zero(): vec2 {
        return vec2._insts[0]
    }

    public static create(x: number = 0, y: number = 0): vec2 {
        let ref = vec2._freed;
        if (ref !== 0) {
            vec2._freed = vec2._table[ref];
        } else {
            vec2._count++;
            ref = vec2._count;
        }
        vec2._table[ref] = -1;
        if (vec2._insts[ref] === undefined) {
            vec2._insts[ref] = new vec2(x, y);
            vec2._insts[ref]._ref = ref;
        } else {
            vec2._insts[ref].setTo(x, y);
        }
        return vec2._insts[ref];
    }

    public static _init() {
        vec2._insts[0] = new vec2(0, 0)
    }

    public static free(...vec2s: vec2[]) {
        for (const elem of vec2s) {
            elem.free()
        }
    }

    public x: number
    public y: number
    private _ref: number

    private constructor(x: number, y: number) {
        this.setTo(x, y)
    }

    public free() {
        if (this._ref === 0) {
            return
        } else if (vec2._table[this._ref] !== -1) {
            return
        }
        vec2._table[this._ref] = vec2._freed
        vec2._freed = this._ref
    }

    public setTo(x: number, y: number): vec2 {
        this.x = x
        this.y = y
        return this
    }

    public clone(): vec2 {
        return vec2.create(this.x, this.y);
    }

    public add(addend: vec2): vec2 {
        const out = this.clone();
        out.x += addend.x
        out.y += addend.y
        return out
    }

    public subtract(subtrahend: vec2): vec2 {
        const out = this.clone();
        out.x -= subtrahend.x
        out.y -= subtrahend.y
        return out
    }

}

vec2._init();

```