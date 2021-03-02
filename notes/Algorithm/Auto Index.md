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

``` C#
private static readonly int IndexInitSize = 128;
private static readonly int IndexGrow = 128;
private static int IndexFreed = -1;
private static int IndexCount = 0;
private static int[] IndexTable = new int[IndexInitSize];

private static int AllocateIndex()
{
    var index = IndexFreed;
    if (index != -1)
    {
        IndexFreed = IndexTable[index];
    }
    else
    {
        index = IndexCount++;
    }
    if (index >= IndexTable.Length)
    {
        Array.Resize(ref IndexTable, IndexTable.Length + IndexGrow);
    }
    IndexTable[index] = -2;
    return index;
}

private static void FreeIndex(int index)
{
    if (index < 0 || index >= IndexTable.Length)
    {
        Console.WriteLine("NativeBridgeIndex: free null index");
        return;
    }
    else if (IndexTable[index] != -2)
    {
        Console.WriteLine("NativeBridgeIndex: double free index or undefined index");
        return;
    }
    IndexTable[index] = IndexFreed;
    IndexFreed = index;
}
```