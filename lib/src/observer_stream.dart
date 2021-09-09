import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:mobx_widget/src/utils/animated_transition.dart';

class ObserverStream<D, E> extends StatelessWidget {
  final ObservableStream? Function() observableStream;
  final Widget Function(BuildContext context, E error)? onError;
  final Widget Function(BuildContext context)? onUnstarted;
  final Widget Function(BuildContext context)? onNull;
  final Widget Function(BuildContext context, D? data) onData;
  final Transition? transition;

  ObserverStream({
    Key? key,
    required this.onData,
    required this.observableStream,
    this.onError,
    this.onNull,
    this.onUnstarted,
    this.transition,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      if (transition != null)
        return AnimatedTransition(
          transition: transition!,
          child: _getChildWidget(context),
        );

      return _getChildWidget(context);
    });
  }

  _getChildWidget(BuildContext context) {
    ObservableStream? observable = observableStream();
    if (onUnstarted != null &&
        (observable == null || observable.status == StreamStatus.waiting && observable.value == null)) {
      return onUnstarted!(context);
    }
    if (observable?.hasError == true && onError != null) return onError!(context, observable?.error);
    if (observable?.value == null && onNull != null) return onNull!(context);
    return onData(context, observable?.value);
  }
}
