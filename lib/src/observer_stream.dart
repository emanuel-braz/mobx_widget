import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

class ObserverStream extends Observer {

  final ObservableStream Function() observableStream;
  final Widget Function(BuildContext context, dynamic error) onError;
  final Widget Function(BuildContext context) onUnstarted;
  final Widget Function(BuildContext context) onNull;
  final Widget Function(BuildContext context, dynamic data) onData;

  ObserverStream(
      {Key key,
      @required this.onData,
      this.observableStream,
      this.onError,
      this.onNull,
      this.onUnstarted})
      : assert(onData != null),
        assert(observableStream != null),
        super(
            key: key,
            builder: (context) {
              ObservableStream observable = observableStream();
              if (observable.status == StreamStatus.waiting &&
                  observable.value == null &&
                  onUnstarted != null) return onUnstarted(context);
              if (observable.hasError && onError != null)
                return onError(context, observable.error);
              if (observable.value == null && onNull != null)
                return onNull(context);
              return onData(context, observable.value);
            });
}
