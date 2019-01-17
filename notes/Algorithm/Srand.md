``` java
/**
 * Generates a random number based on the seed provided.
 * 
 * @param Seed A number between 0 and 1, used to generate a predictable random number (very optional).
 * 
 * @return A <code>Number</code> between 0 and 1.
 */
static public function srand(Seed: Number): Number
{
    return ((69621 * int(Seed * 0x7FFFFFFF)) % 0x7FFFFFFF) / 0x7FFFFFFF;
}
```

浮点数在传输和计算时都需要测试下精确度。可以考虑改造成种子和随机结果都是整数的方法，
使用方法是，每次随机后的结果是下一次随机的种子。
