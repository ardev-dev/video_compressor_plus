/// Base for the typed constant wrappers in this library.
///
/// Predates Dart's enhanced enums; kept because the constants below are part of
/// the public API inherited from `video_compress`.
abstract class Enum<T> {
  /// Wraps a raw platform [value].
  const Enum(this._value);

  final T _value;

  /// The raw value passed to the platform channel.
  T get value => _value;
}

/// Metadata keys accepted by Android's `MediaMetadataRetriever`.
///
/// The bogus `<int>` type parameter this class carried upstream — which shadowed
/// the real `int` type — was removed; [value] now genuinely resolves to `int`.
///
/// The `SCREAMING_CAPS` names mirror the Android SDK constants one-to-one on
/// purpose, so a key found in Android documentation can be used here verbatim.
/// Each entry documents the API level that introduced it; requesting a key on
/// an older device yields `null` rather than throwing.
class MediaMetadataRetriever extends Enum<int> {
  /// [Android] API level 10
  static const METADATA_KEY_ALBUM = MediaMetadataRetriever(1);

  /// [Android] API level 10
  static const METADATA_KEY_ALBUMARTIST = MediaMetadataRetriever(13);

  /// [Android] API level 10
  static const METADATA_KEY_ARTIST = MediaMetadataRetriever(2);

  /// [Android] API level 10
  static const METADATA_KEY_AUTHOR = MediaMetadataRetriever(3);

  /// [Android] API level 14
  static const METADATA_KEY_BITRATE = MediaMetadataRetriever(20);

  /// [Android] API level 23
  static const METADATA_KEY_CAPTURE_FRAMERATE = MediaMetadataRetriever(25);

  /// [Android] API level 10
  static const METADATA_KEY_CD_TRACK_NUMBER = MediaMetadataRetriever(0);

  /// [Android] API level 10
  static const METADATA_KEY_COMPILATION = MediaMetadataRetriever(15);

  /// [Android] API level 10
  static const METADATA_KEY_COMPOSER = MediaMetadataRetriever(4);

  /// [Android] API level 10
  static const METADATA_KEY_DATE = MediaMetadataRetriever(5);

  /// [Android] API level 10
  static const METADATA_KEY_DISC_NUMBER = MediaMetadataRetriever(14);

  /// [Android] API level 10
  static const METADATA_KEY_DURATION = MediaMetadataRetriever(9);

  /// [Android] API level Q
  static const METADATA_KEY_EXIF_LENGTH = MediaMetadataRetriever(34);

  /// [Android] API level Q
  static const METADATA_KEY_EXIF_OFFSET = MediaMetadataRetriever(33);

  /// [Android] API level 10
  static const METADATA_KEY_GENRE = MediaMetadataRetriever(6);

  /// [Android] API level 14
  static const METADATA_KEY_HAS_AUDIO = MediaMetadataRetriever(16);

  /// [Android] API level 28
  static const METADATA_KEY_HAS_IMAGE = MediaMetadataRetriever(26);

  /// [Android] API level 14
  static const METADATA_KEY_HAS_VIDEO = MediaMetadataRetriever(17);

  /// [Android] API level 28
  static const METADATA_KEY_IMAGE_COUNT = MediaMetadataRetriever(27);

  /// [Android] API level 28
  static const METADATA_KEY_IMAGE_HEIGHT = MediaMetadataRetriever(30);

  /// [Android] API level 28
  static const METADATA_KEY_IMAGE_PRIMARY = MediaMetadataRetriever(28);

  /// [Android] API level 28
  static const METADATA_KEY_IMAGE_ROTATION = MediaMetadataRetriever(31);

  /// [Android] API level 28
  static const METADATA_KEY_IMAGE_WIDTH = MediaMetadataRetriever(29);

  /// [Android] API level 15
  static const METADATA_KEY_LOCATION = MediaMetadataRetriever(23);

  /// [Android] API level 10
  static const METADATA_KEY_MIMETYPE = MediaMetadataRetriever(12);

  /// [Android] API level 10
  static const METADATA_KEY_NUM_TRACKS = MediaMetadataRetriever(10);

  /// [Android] API level 10
  static const METADATA_KEY_TITLE = MediaMetadataRetriever(7);

  /// [Android] API level 28
  static const METADATA_KEY_VIDEO_FRAME_COUNT = MediaMetadataRetriever(32);

  /// [Android] API level 14
  static const METADATA_KEY_VIDEO_HEIGHT = MediaMetadataRetriever(19);

  /// [Android] API level 17
  static const METADATA_KEY_VIDEO_ROTATION = MediaMetadataRetriever(24);

  /// [Android] API level 14
  static const METADATA_KEY_VIDEO_WIDTH = MediaMetadataRetriever(18);

  /// [Android] API level 10
  static const METADATA_KEY_WRITER = MediaMetadataRetriever(11);

  /// [Android] API level 10
  static const METADATA_KEY_YEAR = MediaMetadataRetriever(8);

  /// Wraps the raw Android metadata key [value].
  const MediaMetadataRetriever(super.value);
}
