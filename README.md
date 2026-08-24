# video_compressor_plus

[![pub package](https://img.shields.io/pub/v/video_compressor_plus.svg)](https://pub.dev/packages/video_compressor_plus)

Compress videos, trim them, strip audio, and extract thumbnails — using the
platform's own encoders (`AVAssetExportSession` on iOS/macOS, `MediaCodec` on
Android). No FFmpeg binaries, so **nothing is added to your app's download
size**.

## Why this package exists

This is a maintained continuation of
[`video_compress`](https://pub.dev/packages/video_compress) by
[Jonny Borges](https://github.com/jonataslaw), which has had no release since
February 2025 — 208 open issues, and four unmerged pull requests adding Swift
Package Manager support.

That last point is what forced the fork. Flutter warns:

> The following plugins do not support Swift Package Manager for ios:
> `video_compress` — This will become an error in a future version of Flutter.

In a project that has otherwise migrated to SPM, `video_compress` is often the
**only** plugin left on CocoaPods, keeping a whole build system alive for one
dependency. This package fixes that and keeps everything else identical.

All credit for the original work belongs to Jonny Borges and the upstream
contributors. Released under the same MIT license.

## Migrating from `video_compress`

Change the import. That is the whole migration:

```diff
- import 'package:video_compress/video_compress.dart';
+ import 'package:video_compressor_plus/video_compressor_plus.dart';
```

`VideoCompress`, `VideoQuality`, `MediaInfo` and every method keep their names,
signatures, and behaviour. See the [CHANGELOG](CHANGELOG.md) for the one small
type-level exception.

## Usage

```dart
import 'package:video_compressor_plus/video_compressor_plus.dart';

// Report progress — subscribe before you start.
final subscription = VideoCompress.compressProgress$.subscribe(
  (progress) => print('$progress%'),
);

final info = await VideoCompress.compressVideo(
  file.path,
  quality: VideoQuality.MediumQuality,
  deleteOrigin: false,
  includeAudio: true,
);

subscription.unsubscribe();
```

Trim a clip and drop its audio:

```dart
final info = await VideoCompress.compressVideo(
  file.path,
  startTime: 5,        // seconds
  duration: 15,        // seconds
  includeAudio: false,
);
```

Extract a thumbnail:

```dart
final bytes = await VideoCompress.getByteThumbnail(file.path, quality: 50);
final file  = await VideoCompress.getFileThumbnail(path, quality: 50);
```

Cancel a running compression:

```dart
await VideoCompress.cancelCompression();
```

See [`example/`](example) for a complete app.

## Platform support

| Platform | Supported | Encoder |
| --- | --- | --- |
| Android | ✅ API 21+ | `MediaCodec` via [Transcoder](https://github.com/natario1/Transcoder) |
| iOS | ✅ 12.0+ | `AVAssetExportSession` |
| macOS | ✅ | `AVAssetExportSession` |

---

## Upstream documentation
-------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------ | ------------------- |
| getByteThumbnail  | String `path`[video path], int `quality`(1-100)[thumbnail quality], int `position`[Get a thumbnail from video position]                                                                                                                                                                                                                       | get thumbnail from video `path`                                                                  | `Future<Uint8List>` |
| getFileThumbnail  | String `path`[video path], int `quality`(1-100)[thumbnail quality], int `position`[Get a thumbnail from video position]                                                                                                                                                                                                                       | get thumbnail file from video `path`                                                             | `Future<File>`      |
| getMediaInfo      | String `path`[video path]                                                                                                                                                                                                                                                                                                                     | get media information from video `path`                                                          | `Future<MediaInfo>` |
| compressVideo     | String `path`[video path], VideoQuality `quality`[compressed video quality], bool `deleteOrigin`[delete the origin video], int `startTime`[compression video start time], int `duration`[compression video duration from start time], bool `includeAudio`[is include audio in compressed video], int `frameRate`[compressed video frame rate] | compression video at origin video `path`                                                         | `Future<MediaInfo>` |
| cancelCompression | `none`                                                                                                                                                                                                                                                                                                                                        | cancel compressing                                                                               | `Future<void>`      |
| deleteAllCache    | `none`                                                                                                                                                                                                                                                                                                                                        | Delete all files generated by 'video_compress' will delete all files located at 'video_compress' | `Future<bool>`      |

## Subscriptions
| Subscriptions     | Description                              | Stream            |
| ----------------- | ---------------------------------------- | ----------------- |
| compressProgress$ | Subscribe the compression progress steam | double `progress` |

## Contribute

Contributions are always welcome!
<!-- Please read the [contribution guidelines](contributing.md) first. -->

## acknowledgment

Inspired by the flutter_ffmpeg library.
https://github.com/rurico/flutter_video_compress

