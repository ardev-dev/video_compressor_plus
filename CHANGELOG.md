## 4.0.2

Fixes the CocoaPods build, which was broken in 4.0.0 and 4.0.1.

- The iOS and macOS podspecs still pointed `source_files` at the pre-rename
  path (`video_compress/Sources/video_compress/**/*.swift`). CocoaPods matched
  zero files, so no module was produced and any app using CocoaPods failed with
  `Module 'video_compressor_plus' not found`. The Swift Package Manager path was
  unaffected, which is why it went unnoticed.

No Dart or native code changes.

## 4.0.1

- Point `homepage`, `repository`, and `issue_tracker` at the current GitHub
  account (`ardev-dev`). The 4.0.0 metadata still referenced the previous
  account name; those links only worked through a GitHub redirect, which is not
  something a published package should depend on.

No code changes.

## 4.0.0

First release of `video_compressor_plus`, a maintained continuation of
[`video_compress`](https://pub.dev/packages/video_compress) by Jonny Borges,
which has had no release since February 2025 (208 open issues, and four
unmerged pull requests adding Swift Package Manager support).

### Added
- **Swift Package Manager support for iOS and macOS.** Flutter warns that
  plugins without SPM support "will become an error in a future version of
  Flutter"; `video_compress` was frequently the last CocoaPods-only plugin in a
  project, keeping an entire build system alive for a single dependency.
  Merged upstream [PR #325](https://github.com/jonataslaw/VideoCompress/pull/325).
- Documentation for every public member, and a test suite covering the platform
  channel contract, `MediaInfo` parsing, and the `VideoQuality` index mapping
  that crosses the channel.

### Changed
- **Android toolchain modernised:** Kotlin 1.9.10 → 2.2.20, Android Gradle
  Plugin 8.1.1 → 8.11.1, `compileSdk` 34 → 36, Java 8 → 17,
  `com.otaliastudios:transcoder` 0.10.5 → 0.11.2. `minSdk` stays at 21.
- Android package renamed from `com.example.video_compress` to
  `com.zinonsoftware.video_compressor_plus` — `com.example` is a placeholder
  that tooling flags.
- `WRITE_EXTERNAL_STORAGE` now carries `maxSdkVersion="28"`; it has been
  unnecessary since Android 10, and requesting it unconditionally is a
  Play Console warning.
- The deprecated `package` attribute was removed from `AndroidManifest.xml`
  (AGP 8 takes it from `namespace`), and `lintOptions` became `lint`.

### Breaking
- **Package name.** Imports become
  `package:video_compressor_plus/video_compressor_plus.dart`. Everything else
  is unchanged: `VideoCompress`, `VideoQuality`, `MediaInfo`, and every method
  keep their names, signatures, and behaviour. Migration is a find-and-replace
  of the import line.
- `MediaMetadataRetriever` no longer declares a type parameter. It was written
  as `class MediaMetadataRetriever<int>`, where `int` was a type parameter
  shadowing the real `int` type. `value` now genuinely resolves to `int`. Only
  code that wrote `MediaMetadataRetriever<…>` explicitly is affected — using
  the constants is not.

No compression, trimming, or thumbnail logic was modified.
