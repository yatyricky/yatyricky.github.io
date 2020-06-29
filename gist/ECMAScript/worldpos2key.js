class SVector2Int {
    static Add(a, b) {
        return a + b - 800020000;
    }
    static Subtract(a, b) {
        return a - b + 800020000;
    }
    static X(v) {
        return v - Math.floor(v / 40000)* 40000 - 20000;
    }
    static Y(v) {
        return Math.floor(v / 40000) - 20000;
    }
    static OutXY(v,out) {
        var t = Math.floor(v / 40000)
        out[0] = v - t* 40000 - 20000
        out[1]=t-20000
    }
    static New(x, y) {
        return (y + 20000) * 40000 + x + 20000;
    }
}

for (let i = 0; i < 10; i++) {
    const x1 = -1254 + i * 222
    const y1 = -999 + i * 654
    const x2 = -3333 + i * 777
    const y2 = -100 + i * 13

    const sv1 = SVector2Int.New(x1,y1)
    const sv2 = SVector2Int.New(x2,y2)
    console.log(`v1=(${x1},${y1}) sv1=(${SVector2Int.X(sv1)},${SVector2Int.Y(sv1)}) pass=${SVector2Int.X(sv1)===x1&&SVector2Int.Y(sv1)===y1}`)
    console.log(`v2=(${x2},${y2}) sv2=(${SVector2Int.X(sv2)},${SVector2Int.Y(sv2)}) pass=${SVector2Int.X(sv2)===x2&&SVector2Int.Y(sv2)===y2}`)

    const ax = x1+x2
    const ay = y1+y2
    const shouldSA = SVector2Int.New(ax,ay)
    const sa = SVector2Int.Add(sv1,sv2)
    console.log(`expected=${shouldSA} got=${sa} pass=${shouldSA===sa} diff=${shouldSA-sa}`)
    const xy=[]
    SVector2Int.OutXY(sa,xy)
    const sax = SVector2Int.X(sa)
    const say = SVector2Int.Y(sa)
    console.log(`Add=(${ax},${ay}) SA=(${xy[0]},${xy[1]}) pass=${ax===xy[0]&&ay===xy[1]}`)
}