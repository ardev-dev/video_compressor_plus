import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'subscription.dart';

/// Shared plumbing between the Dart API and the platform channel.
///
/// Owns the [MethodChannel], the compression-in-progress flag, and the progress
/// observable the native side pushes updates into.
class CompressMixin {
  /// Emits compression progress as a percentage between 0 and 100.
  ///
  /// Subscribe before starting a compression; the native side only emits while
  /// something is listening.
  final compressProgress$ = ObservableBuilder<double>();
  final _channel = const MethodChannel('video_compressor_plus');

  /// Wires the native progress callbacks. Called once per instance.
  @protected
  void initProcessCallback() {
    _channel.setMethodCallHandler(_progressCallback);
  }

  /// The platform channel used for every native call.
  MethodChannel get channel => _channel;

  bool _isCompressing = false;

  /// Whether a compression is currently running.
  ///
  /// Only one runs at a time; starting another while this is `true` throws.
  bool get isCompressing => _isCompressing;

  /// Updates [isCompressing]. For internal use by the compression methods.
  @protected
  void setProcessingStatus(bool status) {
    _isCompressing = status;
  }

  Future<void> _progressCallback(MethodCall call) async {
    switch (call.method) {
      case 'updateProgress':
        final progress = double.tryParse(call.arguments.toString());
        if (progress != null) compressProgress$.next(progress);
        break;
    }
  }
}
