## 4.0.0

Maintained continuation of [`video_compress`](https://pub.dev/packages/video_compress)
by Jonny Borges, which has been unmaintained since February 2025.

- **Swift Package Manager support for iOS and macOS.** Flutter warns that plugins
  without SPM support "will become an error in a future version of Flutter";
  `video_compress` was often the last CocoaPods-only plugin left in a project,
  keeping an entire build system alive for one dependency. Merged upstream
  [PR #325](https://github.com/jonataslaw/VideoCompress/pull/325).
- **Breaking (name only):** the package is `video_compress_new`, so imports become
  `package:video_compress_new/video_compress_new.dart`. The API is unchanged —
  `VideoCompress`, `VideoQuality`, `MediaInfo` and every method keep their
  signatures and behaviour. Migration is a find-and-replace of the import.

No compression, trimming, or thumbnail logic was modified.
