import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:video_compressor_plus/video_compressor_plus.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel('video_compressor_plus');
  final List<MethodCall> log = <MethodCall>[];

  setUp(() {
    log.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall call) async {
      log.add(call);
      switch (call.method) {
        case 'compressVideo':
          return '{"path":"/tmp/out.mp4","width":640,"height":480,'
              '"filesize":1024,"duration":3000.0}';
        case 'getMediaInfo':
          return '{"path":"/tmp/in.mp4","width":1920,"height":1080,'
              '"filesize":8388608,"duration":30000.0}';
        case 'getByteThumbnail':
          return Uint8List.fromList(<int>[1, 2, 3]);
        default:
          return null;
      }
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  group('MediaInfo', () {
    test('round-trips through JSON', () {
      final MediaInfo info = MediaInfo.fromJson(<String, dynamic>{
        'path': '/tmp/a.mp4',
        'title': 'clip',
        'width': 1280,
        'height': 720,
        'filesize': 2048,
        'duration': 5000.0,
      });

      expect(info.path, '/tmp/a.mp4');
      expect(info.width, 1280);
      expect(info.duration, 5000.0);
      expect(info.file, isA<File>());

      final Map<String, dynamic> json = info.toJson();
      expect(json['path'], '/tmp/a.mp4');
      expect(json['height'], 720);
    });

    test('parses a duration sent as a string', () {
      final MediaInfo info = MediaInfo.fromJson(<String, dynamic>{
        'path': '/tmp/a.mp4',
        'duration': '1500',
      });
      expect(info.duration, 1500.0);
    });

    test('omits null orientation and isCancel from JSON', () {
      final MediaInfo info = MediaInfo(path: '/tmp/a.mp4');
      final Map<String, dynamic> json = info.toJson();
      expect(json.containsKey('orientation'), isFalse);
      expect(json.containsKey('isCancel'), isFalse);
    });
  });

  group('VideoQuality', () {
    test('exposes the full set of presets in a stable order', () {
      expect(VideoQuality.values.first, VideoQuality.DefaultQuality);
      expect(VideoQuality.values, hasLength(8));
      // The index is what crosses the channel — pinning it guards the contract.
      expect(VideoQuality.LowQuality.index, 1);
      expect(VideoQuality.Res1920x1080Quality.index, 7);
    });
  });

  group('MediaMetadataRetriever', () {
    test('exposes raw Android keys as int values', () {
      expect(MediaMetadataRetriever.METADATA_KEY_ALBUM.value, 1);
      expect(MediaMetadataRetriever.METADATA_KEY_ARTIST.value, 2);
    });
  });

  group('VideoCompress', () {
    test('compressVideo forwards the quality index and returns info', () async {
      final MediaInfo? info = await VideoCompress.compressVideo(
        '/tmp/in.mp4',
        quality: VideoQuality.LowQuality,
        deleteOrigin: false,
        includeAudio: true,
      );

      expect(info?.path, '/tmp/out.mp4');
      expect(info?.width, 640);

      final MethodCall call = log.single;
      expect(call.method, 'compressVideo');
      final Map<Object?, Object?> args = call.arguments as Map<Object?, Object?>;
      expect(args['path'], '/tmp/in.mp4');
      expect(args['quality'], VideoQuality.LowQuality.index);
      expect(args['deleteOrigin'], false);
      expect(args['includeAudio'], true);
    });

    test('getMediaInfo reads the source without compressing', () async {
      final MediaInfo info = await VideoCompress.getMediaInfo('/tmp/in.mp4');
      expect(info.width, 1920);
      expect(info.filesize, 8388608);
      expect(log.single.method, 'getMediaInfo');
    });

    test('getByteThumbnail returns raw bytes', () async {
      final Uint8List? bytes =
          await VideoCompress.getByteThumbnail('/tmp/in.mp4');
      expect(bytes, <int>[1, 2, 3]);
      expect(log.single.method, 'getByteThumbnail');
    });

    test('isCompressing is false when idle', () {
      expect(VideoCompress.isCompressing, isFalse);
    });
  });
}
