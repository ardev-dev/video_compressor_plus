import 'dart:async';

import 'dart:ui';

/// A minimal observable used to report compression progress.
///
/// Wraps a [StreamController] and hands out a [Subscription] whose
/// [Subscription.unsubscribe] closes the current controller and installs a
/// fresh one, so the same observable can be listened to again after a
/// compression finishes.
class ObservableBuilder<T> {
  StreamController<T> _observable = StreamController();

  /// Whether nothing is listening yet.
  ///
  /// Used to avoid emitting progress into a stream no one reads.
  bool notSubscribed = true;

  /// Emits [value] to the current listener, if any.
  void next(T value) {
    _observable.add(value);
  }

  /// Starts listening and returns the handle used to stop.
  ///
  /// The callbacks mirror [Stream.listen].
  Subscription subscribe(
    void Function(T event) onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    notSubscribed = false;
    _observable.stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
    return Subscription(() {
      _observable.close();

      // Create a new instance to avoid errors
      _observable = StreamController();
    });
  }
}

/// Handle returned by [ObservableBuilder.subscribe].
class Subscription {
  /// Wraps the [unsubscribe] callback.
  const Subscription(this.unsubscribe);

  /// Stops listening and releases the underlying stream.
  final VoidCallback unsubscribe;
}
