# VideoConverter

VideoConverter is a SwiftUI iOS app that picks a media file and has code paths for exporting it as another container. The screen is a file importer, a format menu, an export name field, and a convert button. The conversion code uses AVFoundation and FFmpegKit.

The **Convert media file** button calls `ConvertWithFFMPEG`. That method runs `FFmpegKit.execute("-version")` and, when security-scoped access to the chosen file succeeds, starts the FFmpegKit session. It does not pass the selected format or the export name into FFmpeg. `ConvertWithAVFoundation` is in the target and is not called by the button. It builds an `AVAssetExportSession` with `AVAssetExportPresetHighestQuality` for `.mp4`, `.mov`, or `.m4v`.

## Prerequisites

- A Mac with Xcode 14.0 or later. The project `compatibilityVersion` and last upgrade check are Xcode 14.0.
- Swift 5.0. `SWIFT_VERSION` is 5.0.
- An iPhone or iPad on iOS 16.0 or later. `IPHONEOS_DEPLOYMENT_TARGET` is 16.0. `TARGETED_DEVICE_FAMILY` is `1,2` (iPhone and iPad).
- The VideoConverter target links `Pods/ffmpeg-kit-ios-full-gpl/ffmpegkit.xcframework` and runs the CocoaPods script phases **Check Pods Manifest.lock** and **Embed Pods Frameworks**. This repository does not include a `Podfile`, `Podfile.lock`, or `Pods` directory. Signing style in the target is Automatic.

## Install, build, run, and test

From the repository root, open the project on a Mac:

```bash
open VideoConverter.xcodeproj
```

List what Xcode sees in this project:

```bash
xcodebuild -project VideoConverter.xcodeproj -list
```

Build the VideoConverter target:

```bash
xcodebuild -project VideoConverter.xcodeproj -target VideoConverter -configuration Debug -sdk iphoneos build
```

Debug and Release take their base settings from `Pods/Target Support Files/Pods-VideoConverter/Pods-VideoConverter.debug.xcconfig` and `Pods-VideoConverter.release.xcconfig`. Those files are not in this repository. The build needs them and `ffmpegkit.xcframework`. There is no `Podfile` in this repository for `pod install` to read. The CocoaPods lockfile check in the project prints `Run 'pod install'` when `Podfile.lock` and `Manifest.lock` differ. Those lockfiles are not checked in.

Run the app from Xcode on an iOS 16 iPhone or iPad. There is no shared `.xcscheme` in the repository. Xcode supplies a scheme for the VideoConverter target when the project is opened. The product name is VideoConverter. Marketing version is 1.0 and the current project version is 1.

This repository has no test target and no test files, so there is no test command.

## Usage

1. Launch VideoConverter.
2. Tap **Open** and choose a file. The importer allows `.movie`, `.video`, `.audio`, `.audiovisualContent`, and `.image`.
3. Choose a format in the **FileFormat** menu. The menu lists `mp4`, `mov`, and `m4v` (`FileExtensionSelection`), shown capitalized.
4. Type an export file name.
5. Tap **Convert media file**.

With a selected file URL, **Convert media file** decodes that URL, runs `FFmpegKit.execute("-version")`, and calls `startRunning()` when `startAccessingSecurityScopedResource()` returns true. The format menu and export name are not read on this path. If no file URL has been set, this path force-unwraps `fileURL`.

`ConvertWithAVFoundation` stays in `ConvertMediaViewModel`. It asks for security-scoped access and requires a non-empty export file name. If either check fails, it presents a popover with the text `Choose an export file name or import file`. If both checks pass, it checks export compatibility and calls `exportAsynchronously` with an empty completion handler. The output URL is the imported file's directory, the export name, and the selected extension.

The text under **Open** is `importFileName`. That value is assigned only inside `ConvertWithAVFoundation`.

`scraps.swift` is comments only. It is compiled into the target and does not add UI.

## Layout

```
README.md
VideoConverter.xcodeproj/     Xcode project. No shared scheme file.
VideoConverter/
  VideoConverterApp.swift     App entry. Shows ContentView.
  ContentView.swift           Open, importer, format menu, export name, convert, popover.
  ConvertMediaViewModel.swift FFmpegKit and AVFoundation methods.
  scraps.swift                Commented notes.
  Assets.xcassets/            App icon and accent color catalogs.
  Preview Content/            SwiftUI preview assets.
```

The project file also names `VideoConverter/Info.plist`. That file is not in the repository. The target sets `GENERATE_INFOPLIST_FILE` to YES and sets the launch screen, scene manifest, indirect input events, and iPhone and iPad orientations in build settings.

## License

This repository has no license file.
