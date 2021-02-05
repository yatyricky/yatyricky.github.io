# HashMap

``` java
for (Map.Entry<String, SDKBase> entry : sdks.entrySet())
{
    entry.getValue().start();
}
```

``` m
// To print out all key-value pairs in the NSDictionary myDict
for(id key in myDict)
{
    NSLog(@"key=%@ value=%@", key, [myDict objectForKey:key]);
}
// initialization
NSDictionary *dict = @{@"key1":@"Eezy",@"key2": @"Tutorials"};

NSMutableDictionary *m = [d mutableCopy];
```

contains key

[dict objectForKey:@"key"] == nil

# String

``` java
String s = "abc";
if (s.equals("abc"))
{
    // true
}
NSString* str = [(NSString*)v stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
```

``` m
NSString* s = @"abc";
if ([s isEqualToString:@"abc"])
{
    // true
}
```

string.startsWith

if ([myString hasPrefix:@"http"]).

IsNullOrEmpty

[myString length] == 0

# JSON

``` java
JSONObject data = new JSONObject(json);
```

``` m

```

# Reflection

https://developer.apple.com/documentation/foundation/nsinvocation
```
NSInvocation * invocation = [ NSInvocation new ];

[ invocation setSelector: NSStringFromSelector( @"methodWithArg1:arg2:arg3:" ) ];

// Argument 1 is at index 2, as there is self and _cmd before
[ invocation setArgument: &arg1 atIndex: 2 ];
[ invocation setArgument: &arg2 atIndex: 3 ];
[ invocation setArgument: &arg3 atIndex: 4 ];

[ invocation invokeWithTarget: targetObject ];

// If you need to get the return value
[ invocation getReturnValue: &someVar ];

[ invocation release ];
```