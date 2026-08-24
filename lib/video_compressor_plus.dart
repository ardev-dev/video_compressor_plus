/// Compress videos, trim them, strip audio, and extract thumbnails.
///
/// A maintained continuation of `video_compress`, adding Swift Package Manager
/// support for iOS and macOS. The API is unchanged — start from the
/// [VideoCompress] entry point.
///
/// ```dart
/// final info = await VideoCompress.compressVideo(
///   file.path,
///   quality: VideoQuality.DefaultQuality,
///   deleteOrigin: false,
/// );
/// ```
library;

export 'src/media/media_data.dart';
export 'src/media/media_info.dart';
export 'src/progress_callback/subscription.dart';
export 'src/video_compressor_plus/video_compressor.dart';
export 'src/video_compressor_plus/video_quality.dart';
