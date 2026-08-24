/// Output quality requested when compressing a video.
///
/// These are not fixed bitrates. Each value maps to a native platform setting —
/// an `AVAssetExportPreset*` on iOS/macOS, and a `DefaultVideoStrategy` with a
/// dimension cap on Android. The resulting file size therefore varies between
/// devices even for the same value.
///
/// The `PascalCase` names are intentional: they are part of the inherited
/// `video_compress` API, and renaming them would break every consumer.
enum VideoQuality {
  /// Balanced default — `MediumQuality` on iOS, capped at 720p on Android.
  /// Suitable for most cases.
  DefaultQuality,

  /// Smallest output — `LowQuality` on iOS, capped at 360p on Android.
  LowQuality,

  /// Medium quality — capped at 640p on Android.
  MediumQuality,

  /// Highest available quality. The output may not be much smaller than the
  /// source.
  HighestQuality,

  /// Capped at 640×480.
  Res640x480Quality,

  /// Capped at 960×540.
  Res960x540Quality,

  /// Capped at 1280×720.
  Res1280x720Quality,

  /// Capped at 1920×1080.
  Res1920x1080Quality,
}
