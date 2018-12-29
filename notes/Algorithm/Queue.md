``` ts
/**
 * Sized queue.
 * @author Nef.
 */
class Queue<T> {

    private arr: T[];
    private maxSize: number = 0;
    private idx: number = 0;
    private count: number = 0;

    /**
     * Must specify the max size.
     * @param size
     */
    constructor(size: number) {
        this.maxSize = size;
        this.arr = new Array<T>(this.maxSize);
        this.idx = 0;
    }

    /**
     * Iterate from tail to head.
     * @param callback
     */
    public forEach(callback: (e: T) => void) {
        if (this.count === 0) { return; }
        const start = (this.maxSize + this.idx - this.count) % this.maxSize;
        for (let i = start; i < start + this.count; i++) {
            callback(this.arr[i % this.maxSize]);
        }
    }

    /**
     * Return tail of the queue.
     * @returns {T}
     */
    public tail(): T {
        if (this.count === 0) { return undefined; }
        return this.arr[(this.maxSize + this.idx - this.count) % this.maxSize];
    }

    /**
     * Return next element in the memory and act as enqueued.
     * @returns {T}
     */
    public poke(): T {
        const ret = this.arr[this.idx++ % this.maxSize];
        this.count++;
        if (this.count > this.maxSize) { this.count = this.maxSize; }
        return ret;
    }

    /**
     * Return next element in the memory.
     * @returns {T}
     */
    public headNext(): T {
        return this.arr[this.idx % this.maxSize];
    }

    /**
     * Enqueue. Will overwrite tail if overflow.
     * @param elem
     * @returns {T} Tail if overflow. undefined if not overflow.
     */
    public enqueue(elem: T): T {
        let ret: T = undefined;
        const nextI = this.idx++ % this.maxSize
        this.count++;
        if (this.count > this.maxSize) {
            this.count = this.maxSize;
            ret = this.arr[nextI]
        }
        this.arr[nextI] = elem;
        return ret
    }

    /**
     * Dequeue.
     * @returns {T}
     */
    public dequeue(): T {
        if (this.count === 0) { return undefined; }
        return this.arr[(this.maxSize + this.idx - this.count--) % this.maxSize];
    }

}

```