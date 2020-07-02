``` sh
adb devices
adb [-s device_id] shell pm list packages
adb [-s device_id] shell pm path com.some.app
adb pull some_app_path [destination_path]
```