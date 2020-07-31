## Lua的字节码

### 基本思路

iOS只用64位字节码，32位的直接放弃，Android打两份字节码，运行时判断使用哪一份。

> 最佳实践应该是客户端只包含一份字节码，但是在现有基础上直接加两份是比较省力的做法，毕竟一份字节码也就1M多一点

### 代码

``` sh
# 打资源，生成两份字节码
luajit32 -b -g input.lua output.bytes
luajit64 -b -g input.lua output.bytes
# 然后分别保存到2个目录，比如 lua32 和 lua64
```

``` cs
// 判断字长
if (System.IntPtr.Size == 4)
{
    // files = Read files from lua32
}
else
{
    // files = Read files from lua64
}
```

### 相关的问题

```
tolua.lua: cannot load incompatible bytecode
```

Lua的32/64位字节码分别和32/64运行时不兼容，在32的环境跑64的字节码会报此错误，反之亦然。

hello.lua
``` lua
print("hello")
```

```
luajit32 hello.lua
hello

luajit32 -b -g test.lua test.bytes
luajit32 test.bytes
hello

luajit64 test.bytes
cannot load incompatible bytecode
```

如果项目不在乎泄露源代码，可以

``` cs
AppConst.LuaByteMode = false
```

这样相当于直接执行Lua文本脚本，也就没有字节码的平台差异问题了。
