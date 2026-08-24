import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_compressor_plus/video_compressor_plus.dart';
import 'package:video_compressor_plus_example/video_thumbnail.dart';

void main() => runApp(const ExampleApp());

/// Demonstrates compressing a video and reporting live progress.
class ExampleApp extends StatelessWidget {
  /// Creates the demo app.
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'video_compressor_plus',
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: const CompressPage(),
    );
  }
}

/// Pick a video, compress it, and show the result.
class CompressPage extends StatefulWidget {
  /// Creates the compression page.
  const CompressPage({super.key});

  @override
  State<CompressPage> createState() => _CompressPageState();
}

class _CompressPageState extends State<CompressPage> {
  Subscription? _progressSubscription;
  double _progress = 0;
  MediaInfo? _result;
  String? _error;

  @override
  void initState() {
    super.initState();
    // Subscribe before compressing — the native side only emits while
    // something is listening.
    _progressSubscription = VideoCompress.compressProgress$.subscribe(
      (double value) => setState(() => _progress = value),
    );
  }

  @override
  void dispose() {
    _progressSubscription?.unsubscribe();
    super.dispose();
  }

  Future<File?> _pickVideo() async {
    if (Platform.isMacOS) {
      const typeGroup = XTypeGroup(
        label: 'videos',
        extensions: <String>['mov', 'mp4'],
      );
      final XFile? picked = await openFile(
        acceptedTypeGroups: <XTypeGroup>[typeGroup],
      );
      return picked == null ? null : File(picked.path);
    }
    final XFile? picked =
        await ImagePicker().pickVideo(source: ImageSource.gallery);
    return picked == null ? null : File(picked.path);
  }

  Future<void> _compress() async {
    setState(() {
      _error = null;
      _result = null;
      _progress = 0;
    });

    final File? source = await _pickVideo();
    if (source == null) return;

    try {
      final MediaInfo? info = await VideoCompress.compressVideo(
        source.path,
        quality: VideoQuality.MediumQuality,
        deleteOrigin: false,
        includeAudio: true,
      );
      if (mounted) setState(() => _result = info);
    } on Object catch (e) {
      if (mounted) setState(() => _error = '$e');
    }
  }

  String _size(int? bytes) => bytes == null
      ? '—'
      : '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';

  @override
  Widget build(BuildContext context) {
    final MediaInfo? result = _result;
    return Scaffold(
      appBar: AppBar(
        title: const Text('video_compressor_plus'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Thumbnail demo',
            icon: const Icon(Icons.image_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const ThumbnailPage(),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (VideoCompress.isCompressing) ...<Widget>[
              LinearProgressIndicator(value: _progress / 100),
              const SizedBox(height: 12),
              Text('${_progress.toStringAsFixed(0)}%',
                  textAlign: TextAlign.center),
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: VideoCompress.cancelCompression,
                icon: const Icon(Icons.cancel_outlined),
                label: const Text('Cancel'),
              ),
            ] else ...<Widget>[
              FilledButton.icon(
                onPressed: _compress,
                icon: const Icon(Icons.video_file_outlined),
                label: const Text('Pick and compress a video'),
              ),
            ],
            if (result != null) ...<Widget>[
              const SizedBox(height: 24),
              Text('Size: ${_size(result.filesize)}'),
              Text('Dimensions: ${result.width} × ${result.height}'),
              Text('Duration: ${result.duration?.toStringAsFixed(0)} ms'),
              const SizedBox(height: 8),
              SelectableText(result.path ?? '',
                  style: Theme.of(context).textTheme.bodySmall),
            ],
            if (_error != null) ...<Widget>[
              const SizedBox(height: 24),
              Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
