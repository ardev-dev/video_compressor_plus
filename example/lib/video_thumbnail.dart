import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_compressor_plus/video_compressor_plus.dart';

/// Extracts a thumbnail from a picked video and displays it.
class ThumbnailPage extends StatefulWidget {
  /// Creates the thumbnail demo page.
  const ThumbnailPage({super.key});

  @override
  State<ThumbnailPage> createState() => _ThumbnailPageState();
}

class _ThumbnailPageState extends State<ThumbnailPage> {
  Uint8List? _thumbnail;
  String? _error;

  Future<void> _pickAndExtract() async {
    setState(() {
      _error = null;
      _thumbnail = null;
    });

    final XFile? picked =
        await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (picked == null) return;

    try {
      final Uint8List bytes = await VideoCompress.getByteThumbnail(
            picked.path,
            quality: 50,
            position: -1,
          ) ??
          Uint8List(0);
      if (mounted) setState(() => _thumbnail = bytes);
    } on Object catch (e) {
      if (mounted) setState(() => _error = '$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Uint8List? thumbnail = _thumbnail;
    return Scaffold(
      appBar: AppBar(title: const Text('Thumbnail')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            FilledButton.icon(
              onPressed: _pickAndExtract,
              icon: const Icon(Icons.image_outlined),
              label: const Text('Pick a video and extract a thumbnail'),
            ),
            if (thumbnail != null) ...<Widget>[
              const SizedBox(height: 24),
              Image.memory(thumbnail),
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
