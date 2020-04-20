import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:mobx_widget/src/utils/braz_animated_transition.dart';

class ObserverStream<D, E> extends StatelessWidget {
  final ObservableStream Function() observableStream;
  final Widget Function(BuildContext context, E error) onError;
  final Widget Function(BuildContext context) onUnstarted;
  final Widget Function(BuildContext context) onNull;
  final Widget Function(BuildContext context, D data) onData;
  final BrazTransition transition;

  ObserverStream({
    Key key,
    @required this.onData,
    this.observableStream,
    this.onError,
    this.onNull,
    this.onUnstarted,
    this.transition,
  })  : assert(onData != null),
        assert(observableStream != null),
        super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      if (transition != null)
        return BrazAnimatedTransition(
          transition: transition,
          child: _getChildWidget(context),
        );

      return _getChildWidget(context);
    });
  }

  _getChildWidget(BuildContext context) {
    ObservableStream observable = observableStream();
    if (observable.status == StreamStatus.waiting &&
        observable.value == null &&
        onUnstarted != null) return onUnstarted(context);
    if (observable.hasError && onError != null)
      return onError(context, observable.error);
    if (observable.value == null && onNull != null) return onNull(context);
    return onData(context, observable.value);
  }
}
