---
layout: post
title: Unity3D 移动MM 支付SDK 问题
categories: [unity3d,sdk]
---

## 环境: 

Windows 8.1 x64  
Eclipse Luna  
Unity3D 4.6 / 5.0  
MMBilling 3.1.3  

## 2015-04-20

折腾了很久, 实际上仍未解决问题, 直到上周找到高人指点, 才发现没有那么多繁琐的步骤, 步骤如下：

* 右键点击你的安卓SDK工程, 导出jar文件. 

![Fig](https://raw.githubusercontent.com/yatyricky/yatyricky.github.io/master/public/2015-04-09-unity3d-mmbilling-sdk-1.jpg)

* 将导出的jar放到Unity工程里面, 路径为```\Assets\Plugins\Android\bin```

* 在Unity工程里面, 导出Android Project, 要勾选Google Android Project, 下边的Build按钮才会变成Export 

![Fig](https://raw.githubusercontent.com/yatyricky/yatyricky.github.io/master/public/2015-04-09-unity3d-mmbilling-sdk-2.jpg)

* 随便选个路径放着, 反正是临时用.

* 在Eclipse里面导入刚才在Unity下面导出的工程 

![Fig](https://raw.githubusercontent.com/yatyricky/yatyricky.github.io/master/public/2015-04-09-unity3d-mmbilling-sdk-3.jpg)

* 等Eclipse自动编译好, 直接运行, 大功告成.

### 几点

* 要从Unity导出安卓工程, 然后在其它环境下编译
* 不用手动解包, 复制资源等等
* 如果有奇怪的BUG, 不妨自己重新开一个新的, 因为笔者在前程序哥的基础上, 无论怎么折腾都不行, 之前我们是安卓工程里面接了一大堆安卓SDK, Unity工程里面接了一大堆Unity SDK, 无论用什么方法, 包括导出工程的方法, 都会遇到奇奇怪怪的问题. 于是笔者在浪费了2天时间之后, 决定把当前项目需要的SDK重新写一遍, 并且一律使用安卓SDK, 目前一起接入的只有MM SDK和Talking Data, 然后问题就这样没了. 虽然之前出错的原因没找到, 但是能确定的是, 问题出在以往接入的某个SDK里面, 我也无心去深究具体原因了, 万一某个SDK已经更新并且没BUG了呢… 这种问题, 只能长叹一口气啊!

## 以前的错误（4.5）

### 1. 创建Handler的问题

在接移动的支付SDK时, 发现有一段代码执行不了

```
MMBillingHandler iapHandler = new MMBillingHandler(this.context);
```

我看了一下```Handler```类的文档, 没有发现它会主动抛出异常, 但是构造方法里面有这样一句话, 说明会抛```RuntimeException```

> Default constructor associates this handler with the Looper for the current thread. If this thread does not have a looper, this handler won’t be able to receive messages so an exception is thrown.

于是尝试着抓一抓, 果然发现有问题, 并且是文档中说的looper的问题.

```
04-09 21:47:13.551: D/payment(18950): java.lang.RuntimeException: Can't create handler inside thread that has not called Looper.prepare()
04-09 21:47:13.551: D/payment(18950):   at android.os.Handler.<init>(Handler.java:200)
04-09 21:47:13.551: D/payment(18950):   at android.os.Handler.<init>(Handler.java:114)
04-09 21:47:13.551: D/payment(18950):   at app.megagame.api.MMBillingHandler.<init>(MMBillingHandler.java:19)
04-09 21:47:13.551: D/payment(18950):   at app.megagame.api.MMBilling.<init>(MMBilling.java:58)
04-09 21:47:13.551: D/payment(18950):   at app.megagame.api.MainActivity.initMGPlugin(MainActivity.java:206)
04-09 21:47:13.551: D/payment(18950):   at com.unity3d.player.UnityPlayer.nativeRender(Native Method)
04-09 21:47:13.551: D/payment(18950):   at com.unity3d.player.UnityPlayer.a(Unknown Source)
04-09 21:47:13.551: D/payment(18950):   at com.unity3d.player.UnityPlayer$a.run(Unknown Source)
```

有了异常信息, 接下来的事情就很好办了, 由于我们坚持面向Google编程, 面向Stackoverflow编程的原则, 就找到了如下内容

http://stackoverflow.com/questions/5009816/cant-create-handler-inside-thread-which-has-not-called-looper-prepare

> The error is self-explanatory… doInBackground() runs on a background thread which, since it is not intended to loop, is not connected to a Looper.

虽然看起来和我的问题不太一致, 但是至少得出了**我在不该创建Handler的地方创建了Handler**的结论.

具体原因是我在Unity3D的一个脚本的```void Start() { }```里面调用了一段安卓代码, 而我在这段代码里面创建了```Handler```, 虽然不是很确定, 但是可以初步判断如此被调用的安卓代码是在后台线程执行的, 因此无法创建```Handler```, 最终抛出```RuntimeException```的异常.

最终我把创建```Handler```的相关代码直接放在了安卓```Activity```里面的```onCreate```方法里面, 问题解决.

### 2. 无法初始化

错误关键词:

```
failed to find resource file(CopyrightDeclaration.xml}
failed to find resource file(mmiap.xml}
failed to find resource file(VERSION}

java.lang.NullPointerException
    at org.kxml2.io.KXmlSerializer.writeEscaped(KXmlSerializer.java:96)
    at org.kxml2.io.KXmlSerializer.text(KXmlSerializer.java:536)
    at mm.purchasesdk.core.t.a(Unknown Source)
    at mm.purchasesdk.core.aa.b(Unknown Source)
    at mm.purchasesdk.core.s.loadCopyright(Unknown Source)
    at mm.purchasesdk.core.Purchase.loadCopyright(Unknown Source)
    at mm.purchasesdk.Purchase.createInfo(Unknown Source)
    at mm.purchasesdk.Purchase.init(Unknown Source)
    at app.megagame.api.MMBilling.<init>(MMBilling.java:77)
    at app.megagame.api.MainActivity.onCreate(MainActivity.java:150)
    at android.app.Activity.performCreate(Activity.java:5231)
    at android.app.Instrumentation.callActivityOnCreate(Instrumentation.java:1087)
    at android.app.ActivityThread.performLaunchActivity(ActivityThread.java:2169)
    at android.app.ActivityThread.handleLaunchActivity(ActivityThread.java:2271)
    at android.app.ActivityThread.access$800(ActivityThread.java:144)
    at android.app.ActivityThread$H.handleMessage(ActivityThread.java:1205)
    at android.os.Handler.dispatchMessage(Handler.java:102)
    at android.os.Looper.loop(Looper.java:136)
    at android.app.ActivityThread.main(ActivityThread.java:5146)
    at java.lang.reflect.Method.invokeNative(Native Method)
    at java.lang.reflect.Method.invoke(Method.java:515)
    at com.android.internal.os.ZygoteInit$MethodAndArgsCaller.run(ZygoteInit.java:732)
    at com.android.internal.os.ZygoteInit.main(ZygoteInit.java:566)
    at dalvik.system.NativeStart.main(Native Method)
```

以上错误是因为Unity3D重新打包之后, MM SDK找不到原先要的文件了, 因此我们需要做如下事情. 

（安卓和Unity3D的通讯部分略.）

* 使用解压缩软件解压```mmbilling.x.x.x.jar```, 笔者使用的是3.1.3版本.
* 将```assets/mmiap```目录复制到Unity3D工程的```Assets/Plugins/Android/assets```里面
* 使用Unity3D build apk.
* 因为打出的apk里面缺失文件, 因此会在运行时报错 
  * 使用7z打开apk
  * 删掉里面的```META-INF```解除签名
  * 添加从```mmbilling.x.x.x.jar```里面解出来的```mmiap.xml, CopyrightDeclaration.xml, VERSION```3个文件
  * 签名

因为过程繁琐, 十分不利于DEBUG, 因此我写了个脚本, 放在Eclipse里面的External Tools里面, 方便使用

``` bat
@echo off
echo Unsigning ...
"C:\Program Files\7-Zip\7z.exe" d "D:\Projects\MGPluginUnity\mgplugin.apk" "META-INF" -r
echo OK!
echo Adding MM Billing files ...
"C:\Program Files\7-Zip\7z.exe" u "D:\Projects\MGPluginUnity\mgplugin.apk" "D:\SDK\China Mobile\Keng\*"
echo OK!
echo Signing ...
"C:\Program Files\Java\jdk1.8.0_25\bin\jarsigner.exe" -sigalg SHA1withRSA -digestalg SHA1 -keystore "签名文件路径.???" -storepass 签名密码 -keypass 签名密码 -signedjar "D:\Projects\MGPluginUnity\mgplugin.apk" "D:\Projects\MGPluginUnity\mgplugin.apk" 签名文件的文件名
echo OK!
```

最后整好的apk包结构 

![Fig](https://raw.githubusercontent.com/yatyricky/yatyricky.github.io/master/public/2015-04-09-unity3d-mmbilling-sdk-4.jpg)

* META-INF是需要你删掉, 然后重新签名生成的.
* 绿色标记的文件就是之前缺失的

该脚本简单易懂, 请读者自行修改7z.exe, apk文件, 签名文件密码的路径和参数. 如果有好压, 用好压应该也行. (话说好压是笔者的唯一一个在当年使用盗版xp时, 被预装, 没被我卸载, 然后还喜欢上了的软件)

我的签名命令是找同事要的, 具体参数我也不知道怎么配, 如果我给的jarsigner命令不好用, 请读者自行搜索.

## 参考: 

* 对我有用: http://www.tuicool.com/articles/I73QFb 
* 最早搜到的, 也是网上转载最多的: http://www.j2megame.com/html/xwzx/ty/4164.html 
* 7z API: http://www.dotnetperls.com/7-zip-examples 
* 好压API: http://haozip.2345.com/help/help11-1.htm 
* Unity3D接入移动MM支付SDK全攻略(后来发现的, 加进来): http://www.bubuko.com/infodetail-252598.html