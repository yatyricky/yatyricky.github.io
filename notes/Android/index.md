# OPPO/VIVO安装Debug包 INSTALL_FAILED_TEST_ONLY

https://developer.android.com/guide/topics/manifest/application-element
android:testOnly
指示此应用是否仅用于测试目的。例如，它可能会在自身之外公开功能或数据，这样会导致安全漏洞，但对测试很有用。此类 APK 只能通过 adb 安装，您不能将其发布到 Google Play。
当您点击 Run 图标 时，Android Studio 会自动添加此属性。

导致 AS 中 Run 在大部分手机上只能用`adb install -r -t x.apk` 安装，在OPPO/VIVO手机上直接无法安装，提示 fail 'null'.

在`gradle.properties`中添加`android.injected.testOnly=false`即可

# "Default Activity Not Found" on Android Studio upgrade
If you see that error occur after upgrading versions of IntelliJ IDEA or Android Studio, or after Generating a new APK, you may need to refresh the IDE's cache.
`File -> Invalidate Caches / Restart...`
