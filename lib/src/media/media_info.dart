import 'dart:io';

/// Metadata describing a video file, returned by every `VideoCompress`
/// operation that inspects or produces a video.
///
/// Every field is nullable: the native side reports only what the underlying
/// platform could read from the file, and a codec or container it does not
/// understand simply yields `null` rather than failing the whole call.
class MediaInfo {
  /// Creates media info. Only [path] is required.
  MediaInfo({
    required this.path,
    this.title,
    this.author,
    this.width,
    this.height,
    this.orientation,
    this.filesize,
    this.duration,
    this.isCancel,
    this.file,
  });

  /// Builds media info from the map sent by the platform channel.
  MediaInfo.fromJson(Map<String, dynamic> json) {
    path = json['path'] as String?;
    title = json['title'] as String?;
    author = json['author'] as String?;
    width = json['width'] as int?;
    height = json['height'] as int?;
    orientation = json['orientation'] as int?;
    filesize = json['filesize'] as int?;
    duration = double.tryParse('${json['duration']}');
    isCancel = json['isCancel'] as bool?;
    file = File(path!);
  }

  /// Absolute path of the video file.
  String? path;

  /// Title stored in the file metadata, if any.
  String? title;

  /// Author stored in the file metadata, if any.
  String? author;

  /// Frame width in pixels.
  int? width;

  /// Frame height in pixels.
  int? height;

  /// Rotation in degrees. Android only, API level 17 and above.
  ///
  /// A portrait clip is often stored as landscape with a 90° rotation flag, so
  /// read this before assuming [width] and [height] are the display dimensions.
  int? orientation;

  /// File size in bytes.
  int? filesize;

  /// Duration in milliseconds.
  double? duration;

  /// Whether the operation that produced this info was cancelled.
  bool? isCancel;

  /// The video file at [path], for convenience.
  File? file;

  /// Serialises this info back to a plain map.
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['path'] = path;
    data['title'] = title;
    data['author'] = author;
    data['width'] = width;
    data['height'] = height;
    if (orientation != null) {
      data['orientation'] = orientation;
    }
    data['filesize'] = filesize;
    data['duration'] = duration;
    if (isCancel != null) {
      data['isCancel'] = isCancel;
    }
    data['file'] = File(path!).toString();
    return data;
  }
}
