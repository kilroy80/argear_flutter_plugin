# argear_flutter_plugin

ARGear SDK Flutter Plugin. This plugin supports Android and iOS. All features supported by ARGear SDK are all features supported by ARGear SDK.

# Notice

Flutter Version <= 2.10.5 used this plugin version 0.0.2<br>
Flutter Version >= 3.0.0 used this plugin version 0.0.3

## Getting Started

#### Android

Open the App Level `build.gradle` file and add minSdkVersion 23
```groovy
defaultConfig {
    minSdkVersion 23
}
```

Open the `AndroidManifest.xml` file and add the required device permissions and uses-feature to the file.

```xml
<manifest xmlns:tools="http://schemas.android.com/tools">
    ...
    <uses-permission android:name="android.permission.CAMERA" />
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.RECORD_AUDIO" />
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />

    <uses-feature
            android:glEsVersion="0x00030001"
            android:required="true" />

    <uses-feature
            android:name="android.hardware.camera"
            android:required="true"/>

    <application
            tools:replace="android:label">
    ...
</manifest>
```

#### iOS

Open `info.plist` and add:

- `Privacy - Microphone Usage Description`, and add a note in the Value column. (NSMicrophoneUsageDescription)
- `Privacy - Camera Usage Description`, and add a note in the Value column. (NSCameraUsageDescription)
- `Privacy - Photo Library Usage Description`, and add a note in the Value column. (NSPhotoLibraryUsageDescription, NSPhotoLibraryAddUsageDescription)

## Usage

```dart
// Build your layout
// apiUrl, apiKey, secretKey, authKey is generated on the ARGear homepage.
// ARGear Homepage : https://argear.io
@override
Widget build(BuildContext context) {
  return MaterialApp(
    home: Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ARGearView(
                onArGearViewCreated: _onArGearViewCreated,
                apiUrl : Config.apiUrl,
                apiKey: Config.apiKey,
                secretKey: Config.secretKey,
                authKey: Config.authKey,
                onCallback: (method, arguments) {
                  debugPrint(method.toString() + ' / ' + arguments.toString());
                },
                onPre: (method, arguments) {
                  debugPrint(method.toString() + ' / ' + arguments.toString());
                },
                onComplete: (method, arguments) {
                  debugPrint(method.toString() + ' / ' + arguments.toString());
                }
            ),
          ],
        ),
      ),
    ),
  );
}

void _onArGearViewCreated(ARGearController controller) {
}
```
