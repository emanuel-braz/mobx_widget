import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

class ObserverStreamWidget extends StatefulWidget {
  final ObservableStream Function() observableStream;
  final Widget Function(BuildContext context, dynamic error) onError;
  final Widget Function(BuildContext context) onUnstarted;
  final Widget Function(BuildContext context) onNull;
  final Widget Function(BuildContext context, dynamic data) onData;

  const ObserverStreamWidget(
      {Key key,
      @required this.onData,
      this.observableStream,
      this.onError,
      this.onNull,
      this.onUnstarted})
      : assert(onData != null),
        assert(observableStream != null),
        super(key: key);

  @override
  _ObserverStreamWidgetState createState() => _ObserverStreamWidgetState();
}

class _ObserverStreamWidgetState extends State<ObserverStreamWidget> {
  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      ObservableStream observable = widget.observableStream();
      if (observable.status == StreamStatus.waiting &&
          observable.value == null &&
          widget.onUnstarted != null) return widget.onUnstarted(context);
      if (observable.hasError && widget.onError != null)
        return widget.onError(context, observable.error);
      if (observable.value == null && widget.onNull != null)
        return widget.onNull(context);
      return widget.onData(context, observable.value);
    });
  }
}
